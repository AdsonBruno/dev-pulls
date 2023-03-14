import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});

  Future<void> auth() async {
    await httpClient.request(url: url);
  }
}

abstract class HttpClient {
  Future<void> request({required String url});
}

class HttpClientSpy extends Mock implements HttpClient {
  @override
  Future<void> request({required String url}) async => {
        super.noSuchMethod(Invocation.method(#request, [], {#url: url}))
      };
}

void main() {
  test('Should call HttpClient with correct URL', () async {
    final httpClient = HttpClientSpy();
    final url = faker.internet.httpUrl();
    final sut = RemoteAuthentication(httpClient: httpClient, url: url);

    when(httpClient.request(url: url)).thenAnswer((_) async {});
    await sut.auth();

    verify(httpClient.request(url: url)).called(1);
  });
}
