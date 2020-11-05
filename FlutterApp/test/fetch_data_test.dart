import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:se7/Data.dart';

import 'package:test/test.dart';

// Create a MockClient using the Mock class provided by the Mockito package.
// Create new instances of this class in each test.
class MockClient extends Mock implements http.Client {}

main() {
  group('fetchData', () {
      test('returns a Post if the http call completes successfully', () async {
        final client = MockClient();

        // Use Mockito to return a successful response when it calls the
        // provided http.Client.
        when(client.get('http://develop-api-invalideparkeren.nl/api/parkingplace/read.php'))
            .thenAnswer((_) async => http.Response('{"title": "Test"}', 200));

        expect(await fetchData(client), const TypeMatcher<Post>());
      });

      test('throws an exception if the http call completes with an error', () {
        final client = MockClient();

        // Use Mockito to return an unsuccessful response when it calls the
        // provided http.Client.
        when(client.get('http://develop-api-invalideparkeren.nl/api/parkingplace/read.php'))
            .thenAnswer((_) async => http.Response('Not Found', 404));

        expect(fetchData(client), throwsException);
      });

      test('returns a Post if the http call completes successfully with specific variables', () async{
        String lat = "52.071510";
        String lon = "2.495053";
        String rad = "0.5";

        final client= MockClient();

        // Use Mockito to return a successful response when it calls the
        // provided http.Client.
        when(client.get('http://develop-api-invalideparkeren.nl/api/parkingplace/read_nearby.php?' + "Lat=" + lat + "&Lon=" + lon + "&Rad=" + rad))
            .thenAnswer((_) async => http.Response('{"title": "Test"}', 200));

        expect(await fetchSpecificData(client), const TypeMatcher<Post>());
      });
    });
    group("fetchReviews", () {
      test('returns a Post if the http call completes successfully getting reviews', () async{
        final client = MockClient();

        // Use Mockito to return a successful response when it calls the
        // provided http.Client.
        when(client.get('http://develop-api-invalideparkeren.nl/api/review/read.php'))
            .thenAnswer((_) async => http.Response('{"title": "Test"}', 200));

        expect(await fetchReviews(client), const TypeMatcher<Post>());
      });

      test('returns a Post if the http call completes successfully getting a specific review', () async{
        final client = MockClient();

        // Use Mockito to return a successful response when it calls the
        // provided http.Client.
        when(client.get('http://develop-api-invalideparkeren.nl/api/review/read.php?places=5', headers: anyNamed("headers")))
            .thenAnswer((_) async => http.Response('{"title": "Test"}', 200));

        expect(await fetchSpecificReview(client), const TypeMatcher<Post>());
      });

      test('returns a Post if the http call completes successfully posting a review', () async{
        final client = MockClient();

        // Use Mockito to return a successful response when it calls the
        // provided http.Client.
        when(client.post('http://develop-api-invalideparkeren.nl/api/review/create.php', headers: anyNamed("headers"), body: anyNamed("body")))
            .thenAnswer((_) async => http.Response('{"title": "Test"}', 200));

        expect(await postReview(client), const TypeMatcher<Post>());
      });

      test('returns a Post if the http call completes successfully getting the average ratings', () async{
        final client = MockClient();

        // Use Mockito to return a successful response when it calls the
        // provided http.Client.
        when(client.get('http://develop-api-invalideparkeren.nl/api/review/read_average_rating.php'))
            .thenAnswer((_) async => http.Response('{"title": "Test"}', 200));

        expect(await fetchAverageRating(client), const TypeMatcher<Post>());
      });

      test('returns a Post if the http call completes successfully getting a specific average rating', () async{
        final client = MockClient();

        // Use Mockito to return a successful response when it calls the
        // provided http.Client.
        when(client.get('http://develop-api-invalideparkeren.nl/api/review/read_average_rating.php?Places=5'))
            .thenAnswer((_) async => http.Response('{"title": "Test"}', 200));

        expect(await fetchSpecificAverageRating(client), const TypeMatcher<Post>());
      });
    });
}