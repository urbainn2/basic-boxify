export 'connectivity_manager.dart';
export 'database_service.dart';
export 'deep_link_service.dart';
export 'firebase_services.dart';
export 'notification_service.dart';
export 'player_service.dart';
export 'playlist_service.dart';
export 'purchase_listener_mixin.dart';
export 'storage_service.dart';

// The Repository pattern is a way to organize code such that data operations are isolated
//from the rest of the code. Repositories usually sit between the data source and the business logic
// in an application.

// A repository is primarily used to abstract away the specific details of retrieving data.
//For example, your app might fetch data from a server through an API,
//from a local SQLite database, from shared preferences, etc.
//The repository's job is to fetch the data and return it in a consistent format, regardless of its source.

// On the other hand, a Service is used to wrap complex business operations
//and process related tasks. Services are typically stateless and their methods
// correspond to business operations. They contain the "business logic" of an application.
