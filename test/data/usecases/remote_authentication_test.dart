import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});

  Future<void> auth() async {
    await httpClient.request(url: url, method: 'post');
  }
}

abstract class HttpClient {
  Future<void> request({
    required String url,
    required String method,
  });
}

class HttpClientSpy extends Mock implements HttpClient {
  @override
  Future<void> request({required String url, required String method}) async => {
        super.noSuchMethod(Invocation.method(#request, [], {
          #url: url,
          #method: method,
        }))
      };
}

void main() {
  late RemoteAuthentication sut;
  late String url;
  late HttpClient httpClient;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
  });
  test('Should call HttpClient with correct URL', () async {
    when(httpClient.request(url: url, method: 'post')).thenAnswer((_) async {});
    await sut.auth();

    verify(httpClient.request(
      url: url,
      method: 'post',
    )).called(1);
  });
}
