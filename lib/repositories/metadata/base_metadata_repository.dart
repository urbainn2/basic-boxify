abstract class BaseMetaDataRepository {
  Future<Map<String, DateTime>> getLastUpdatedTimestamps();
}
