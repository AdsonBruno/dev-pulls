import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:programmer_for_dev/domain/usecases/usecases.dart';

import 'package:programmer_for_dev/data/usecases/usecases.dart';
import 'package:programmer_for_dev/data/http/http.dart';

class HttpClientSpy extends Mock implements HttpClient {
  @override
  Future<void> request({
    required String url,
    required String method,
    Map? body,
  }) async =>
      {
        super.noSuchMethod(Invocation.method(#request, [], {
          #url: url,
          #method: method,
          #body: body,
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
    final params = AuthenticationParams(
      email: faker.internet.email(),
      password: faker.internet.password(),
    );
    when(httpClient.request(url: url, method: 'post')).thenAnswer((_) async {});
    await sut.auth(params);

    verify(httpClient.request(
        url: url,
        method: 'post',
        body: {'email': params.email, 'password': params.password})).called(1);
  });
}
