import 'package:mocktail/mocktail.dart';
import 'package:storage_client/src/fetch.dart';
import 'package:storage_client/storage_client.dart';
import 'package:test/test.dart';

const storageUrl = 'http://localhost:8000/storage/v1';
const storageKey =
    'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJzdXBhYmFzZSIsImlhdCI6MTYwMzk2ODgzNCwiZXhwIjoyNTUwNjUzNjM0LCJhdWQiOiIiLCJzdWIiOiIzMTdlYWRjZS02MzFhLTQ0MjktYTBiYi1mMTlhN2E1MTdiNGEiLCJSb2xlIjoicG9zdGdyZXMifQ.pZobPtp6gDcX0UbzMmG3FHSlg4m4Q-22tKtGWalOrNo';

final timestamp = (DateTime.now().millisecondsSinceEpoch / 1000).round();
final newBucketName = 'my-new-bucket-$timestamp';

void main() {
  late SupabaseStorageClient client;

  setUp(() {
    // init SupabaseClient with test url & test key
    client = SupabaseStorageClient(
        storageUrl, {'Authorization': 'Bearer $storageKey'});

    // Register default mock values (used by mocktail)
    registerFallbackValue<FileOptions>(const FileOptions(cacheControl: '3600'));
    registerFallbackValue<FetchOptions>(FetchOptions());
  });

  test('List buckets', () async {
    final response = await client.listBuckets();
    expect(response.error, isNull);
    expect(response.data!.length, 4);
  });

  test('Get bucket by id', () async {
    final response = await client.getBucket('bucket2');
    expect(response.data!.name, 'bucket2');
  });

  test('Get bucket with wrong id', () async {
    final response = await client.getBucket('not-exist-id');
    expect(response.error, isNotNull);
  });

  test('Create new bucket', () async {
    final response = await client.createBucket(newBucketName);
    expect(response.data, newBucketName);
  });

  test('Empty bucket', () async {
    final response = await client.emptyBucket(newBucketName);
    expect(response.data, 'Successfully emptied');
  });

  test('Delete bucket', () async {
    final response = await client.deleteBucket(newBucketName);
    expect(response.data, 'Successfully deleted');
  });
}
