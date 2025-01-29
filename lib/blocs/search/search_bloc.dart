import 'dart:async';
import 'package:boxify/app_core.dart';
import 'package:boxify/helpers/search_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:equatable/equatable.dart';
import 'test_container.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  // final UserRepository _userRepository;
  // final TrackRepository _trackRepository;
  // final PlaylistRepository _playlistRepository;

  // final MetaDataRepository _metaDataRepository;
  // final BundleRepository _bundleRepository;

  // final CacheHelper _cacheHelper;
  // final PlaylistHelper _playlistHelper;
  final SearchHelper _searchHelper;
  // final TrackHelper _trackHelper;
  // final UserHelper _userHelper;
  // final FirebaseFirestore _firebaseFirestore;

  SearchBloc({
    required UserRepository userRepository,
    required TrackRepository trackRepository,
    required PlaylistRepository playlistRepository,
    required MetaDataRepository metaDataRepository,
    required StorageRepository storageRepository,
    required BundleRepository bundleRepository,
  })  :
        // _userRepository = userRepository,
        //       _trackRepository = trackRepository,
        //       _playlistRepository = playlistRepository,
        //       _metaDataRepository = metaDataRepository,
        //       _bundleRepository = BundleRepository(),
        //       _cacheHelper = CacheHelper(),
        //       _playlistHelper = PlaylistHelper(),
        _searchHelper = SearchHelper(),
        //       _trackHelper = TrackHelper(),
        //       _userHelper = UserHelper(),
        //       _firebaseFirestore = FirebaseFirestore.instance,
        super(SearchState.initial()) {
    on<SearchPlaylists>(_onSearchPlaylists);
    on<SearchArtists>(_onSearchArtists);
    on<SetSearchType>(_onSetSearchType);
    on<SearchTracks>(_onSearchTracks);
    on<ClearSearch>(_onClearSearch);
    on<ChangeQuery>(_onChangeQuery);
    on<ResetSearch>(_onResetSearch);
  }

  Future<void> _onResetSearch(
    ResetSearch event,
    Emitter<SearchState> emit,
  ) async {
    emit(state.copyWith(status: SearchStatus.initial));
  }

  Future<void> _onSetSearchType(
    SetSearchType event,
    Emitter<SearchState> emit,
  ) async {
    logger.i('_setSearchType: ${event.index}');

    try {
      emit(
        state.copyWith(
          searchTypeIndex: event.index,
        ),
      );
    } catch (err) {
      emit(
        state.copyWith(
          status: SearchStatus.error,
          failure: Failure(
            message: 'SearchBloc._setSearchType: ${err.toString()}.',
          ),
        ),
      );
    }
  }

  Future<void> _onChangeQuery(
    ChangeQuery event,
    Emitter<SearchState> emit,
  ) async {
    logger.i('bloc _changeQuery: ${event.query}');
    emit(
      state.copyWith(
        query: event.query,
        status: SearchStatus.loaded,
      ),
    );
  }

  /// Asynchronously search through tracks based on the provided search query.
  ///
  /// Takes in a [SearchTracks] event, and a function to emit state changes.
  /// The function will search through tracks based on the query inside the
  /// [SearchTracks] event. It will first search for all tracks where the
  /// title starts with the query, then it will sanitize the query and again
  /// search for matching tracks. If there are fewer results than the limit
  /// then fuzzy matching will be used. All search results will be unique and
  /// the final result set will respect the provided limit.
  /// Emits a new state with updated search results.
  ///
  /// Throws an error if something went wrong during the search operation.
  /// Updates the player status to error and provides a failure message.
  ///
  /// [SearchTracks] event - Event containing the search query.
  /// [Emitter<SearchState>] emit - Function to emit state changes.
  Future<void> _onSearchTracks(
    SearchTracks event,
    Emitter<SearchState> emit,
  ) async {
    try {
      logger.i('bloc _searchTracks: ${state.query}');
      var limit = 50;
      List<Track>? results = [];

      // Searching for tracks starting with the search query.
      final startsWithLowercaseQuery = event.tracks
          .where((e) => e.displayTitle
              .toLowerCase()
              .startsWith(state.query.toLowerCase()))
          .toList();

      // If we already have enough results respect the limit and exit.
      if (startsWithLowercaseQuery.length >= limit) {
        final result = startsWithLowercaseQuery.take(limit).toList();
        emit(state.copyWith(
          searchResultsTracks: result,
          status: SearchStatus.loaded,
        ));
        logger.i('emitted searchResultsTracks and returning ${result.length}}');
        return;
      }

      results.addAll(startsWithLowercaseQuery);

      // Sanitizing the search query for the second search.
      final sanitizedQuery = _searchHelper.sanitizeQuery(state.query);

      // Searching for tracks starting with the sanitized query.
      final startsWithSanitizedMatches = event.tracks
          .where((e) => _searchHelper
              .sanitizeQuery(e.displayTitle)
              .startsWith(sanitizedQuery))
          .take(limit - results.length)
          .toList();

      // Add any sanitized matches to the results.
      results.addAll(startsWithSanitizedMatches);

      // Remove duplicate results.
      results = results.toSet().toList();

      var fuzzyMatches = [];
      limit -= results.length; // Update the limit before fuzzy matching.

      if (limit > 0) {
        // If limit is more than 0, perform fuzzy matching.
        try {
          fuzzyMatches = extractTop<TestContainer>(
              query: state.query,
              choices: event.tracks
                  .map((e) => TestContainer(e.displayTitle))
                  .toList(),
              cutoff: 90,
              limit: limit, // Respect the updated limit.
              getter: (x) => x.innerVal);
        } on Exception catch (e) {
          logger.e('error in fuzzyMatches: $e');
        }
      }

      final List<Track> fuzzyMatchingTracks = [];

      // Add the fuzzy matching tracks to the final results.
      if (fuzzyMatches.isNotEmpty) {
        try {
          fuzzyMatchingTracks.addAll(fuzzyMatches
              .map((result) => event.tracks[result.index])
              .toList());
        } catch (err) {
          logger.e('error in fuzzyMatchingTracks.addAll(fuzzyMatches: $err');
        }
      }

      // Add fuzzy matching tracks and remove any potentially added duplicates.
      results += fuzzyMatchingTracks;
      results = results.toSet().toList();

      // Emit the final result set.
      emit(state.copyWith(
        searchResultsTracks: results,
        status: SearchStatus.loaded,
      ));
    } catch (err) {
      // Log the error and update the state with error information.
      logger.e('error in searchTracks bloc: $err');
      state.copyWith(
        status: SearchStatus.error,
        failure:
            const Failure(message: 'Fudgsicles. searchTracks() bombed out.'),
      );
    }
  }

  Future<void> _onClearSearch(
    ClearSearch event,
    Emitter<SearchState> emit,
  ) async {
    emit(state.copyWith(
      searchResultsTracks: [],
      query: '',
      status: SearchStatus.loaded,
    ));
  }


  Future<void> _onSearchPlaylists(
    SearchPlaylists event,
    Emitter<SearchState> emit,
  ) async {
    final query = state.query.toLowerCase();
    final searchResultsTracks = <Playlist>[];
    logger.i('searchPlaylists bloc: $query');

    try {
      final results = event.allPlaylists
          .where((e) => e.name!.toLowerCase().contains(query))
          .toList();
      searchResultsTracks.addAll(results);
      if (searchResultsTracks.length > 30) {
        searchResultsTracks.length = 30;
      }
      // logger.i('searchPlaylists: $searchResultsTracks');

      emit(state.copyWith(
        searchResultsPlaylists: searchResultsTracks,
        status: SearchStatus.loaded,
      ));
    } catch (err) {
      logger.i('psb _searchPlaylists error: $err');
      state.copyWith(
        status: SearchStatus.error,
        failure: const Failure(
          message: 'Fudgsicles. _searchPlaylists() bombed out.',
        ),
      );
    }
  }

  Future<void> _onSearchArtists(
    SearchArtists event,
    Emitter<SearchState> emit,
  ) async {
    final query = state.query.toLowerCase();
    // final results = <User>[];
    logger.i('searchPlaylists bloc: $query');

    try {
      final results = event.allArtists
          .where((e) => e.username.toLowerCase().contains(query))
          .toList();
      // results.addAll(results);
      if (results.length > 30) {
        results.length = 30;
      }
      emit(state.copyWith(
        searchResultsUsers: results,
        status: SearchStatus.loaded,
      ));
    } catch (err) {
      logger.i('psb _searchArtists error: $err');
      state.copyWith(
        status: SearchStatus.error,
        failure:
            const Failure(message: 'Fudgsicles. searchArtists() bombed out.'),
      );
    }
  }
}
