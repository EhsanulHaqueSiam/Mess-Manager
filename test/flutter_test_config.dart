import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

/// Global test configuration — prevents GoogleFonts from making network calls.
/// Returns empty font data so tests don't crash on missing fonts.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  HttpOverrides.global = _TestHttpOverrides();
  await testMain();
}

class _TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _TestHttpClient();
  }
}

/// HTTP client that returns empty 200 responses for all requests.
/// Prevents GoogleFonts from hitting the network during tests.
class _TestHttpClient implements HttpClient {
  @override
  Future<HttpClientRequest> getUrl(Uri url) async => _TestHttpRequest(url);
  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) async =>
      _TestHttpRequest(url);
  @override
  Future<HttpClientRequest> headUrl(Uri url) async => _TestHttpRequest(url);

  // Required overrides
  @override set autoUncompress(bool value) {}
  @override bool get autoUncompress => true;
  @override set connectionTimeout(Duration? timeout) {}
  @override Duration? get connectionTimeout => null;
  @override set idleTimeout(Duration timeout) {}
  @override Duration get idleTimeout => const Duration(seconds: 15);
  @override set maxConnectionsPerHost(int? maxConnections) {}
  @override int? get maxConnectionsPerHost => null;
  @override set userAgent(String? value) {}
  @override String? get userAgent => null;
  @override set connectionFactory(Future<ConnectionTask<Socket>> Function(Uri url, String? proxyHost, int? proxyPort)? f) {}
  @override set findProxy(String Function(Uri url)? f) {}
  @override set authenticate(Future<bool> Function(Uri url, String scheme, String? realm)? f) {}
  @override set authenticateProxy(Future<bool> Function(String host, int port, String scheme, String? realm)? f) {}
  @override set badCertificateCallback(bool Function(X509Certificate cert, String host, int port)? callback) {}
  @override set keyLog(Function(String line)? callback) {}
  @override void addCredentials(Uri url, String realm, HttpClientCredentials credentials) {}
  @override void addProxyCredentials(String host, int port, String realm, HttpClientCredentials credentials) {}
  @override void close({bool force = false}) {}

  @override
  Future<HttpClientRequest> open(String method, String host, int port, String path) async =>
      _TestHttpRequest(Uri.parse('http://$host:$port$path'));
  @override
  Future<HttpClientRequest> delete(String host, int port, String path) async =>
      _TestHttpRequest(Uri.parse('http://$host:$port$path'));
  @override
  Future<HttpClientRequest> deleteUrl(Uri url) async => _TestHttpRequest(url);
  @override
  Future<HttpClientRequest> get(String host, int port, String path) async =>
      _TestHttpRequest(Uri.parse('http://$host:$port$path'));
  @override
  Future<HttpClientRequest> head(String host, int port, String path) async =>
      _TestHttpRequest(Uri.parse('http://$host:$port$path'));
  @override
  Future<HttpClientRequest> patch(String host, int port, String path) async =>
      _TestHttpRequest(Uri.parse('http://$host:$port$path'));
  @override
  Future<HttpClientRequest> patchUrl(Uri url) async => _TestHttpRequest(url);
  @override
  Future<HttpClientRequest> post(String host, int port, String path) async =>
      _TestHttpRequest(Uri.parse('http://$host:$port$path'));
  @override
  Future<HttpClientRequest> postUrl(Uri url) async => _TestHttpRequest(url);
  @override
  Future<HttpClientRequest> put(String host, int port, String path) async =>
      _TestHttpRequest(Uri.parse('http://$host:$port$path'));
  @override
  Future<HttpClientRequest> putUrl(Uri url) async => _TestHttpRequest(url);
}

class _TestHttpRequest implements HttpClientRequest {
  final Uri _uri;
  _TestHttpRequest(this._uri);

  @override Uri get uri => _uri;
  @override HttpHeaders get headers => _TestHttpHeaders();
  @override String get method => 'GET';
  @override int get contentLength => 0;
  @override set contentLength(int value) {}
  @override bool get persistentConnection => false;
  @override set persistentConnection(bool value) {}
  @override bool get followRedirects => true;
  @override set followRedirects(bool value) {}
  @override int get maxRedirects => 5;
  @override set maxRedirects(int value) {}
  @override bool get bufferOutput => true;
  @override set bufferOutput(bool value) {}
  @override Encoding get encoding => utf8;
  @override set encoding(Encoding value) {}
  @override HttpConnectionInfo? get connectionInfo => null;
  @override List<Cookie> get cookies => [];
  @override Future<HttpClientResponse> get done async => close();

  @override void abort([Object? exception, StackTrace? stackTrace]) {}
  @override void add(List<int> data) {}
  @override void addError(Object error, [StackTrace? stackTrace]) {}
  @override Future addStream(Stream<List<int>> stream) async {}
  @override Future flush() async {}
  @override void write(Object? object) {}
  @override void writeAll(Iterable objects, [String separator = ""]) {}
  @override void writeCharCode(int charCode) {}
  @override void writeln([Object? object = ""]) {}

  @override
  Future<HttpClientResponse> close() async => _TestHttpResponse();
}

class _TestHttpResponse implements HttpClientResponse {
  @override int get statusCode => 200;
  @override String get reasonPhrase => 'OK';
  @override int get contentLength => 0;
  @override HttpHeaders get headers => _TestHttpHeaders();
  @override bool get persistentConnection => false;
  @override bool get isRedirect => false;
  @override List<RedirectInfo> get redirects => [];
  @override HttpConnectionInfo? get connectionInfo => null;
  @override X509Certificate? get certificate => null;
  @override List<Cookie> get cookies => [];
  @override HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override Future<Socket> detachSocket() async => throw UnsupportedError('detachSocket');
  @override Future<HttpClientResponse> redirect([String? method, Uri? url, bool? followLoops]) async => this;

  @override StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    // Return empty stream that completes immediately
    return Stream<List<int>>.fromIterable([Uint8List(0)])
        .listen(onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  // Stream interface
  @override Future<bool> any(bool Function(List<int>) test) async => false;
  @override Stream<List<int>> asBroadcastStream({void Function(StreamSubscription<List<int>>)? onListen, void Function(StreamSubscription<List<int>>)? onCancel}) => const Stream.empty();
  @override Stream<E> asyncExpand<E>(Stream<E>? Function(List<int>) convert) => const Stream.empty();
  @override Stream<E> asyncMap<E>(FutureOr<E> Function(List<int>) convert) => const Stream.empty();
  @override Stream<R> cast<R>() => const Stream.empty();
  @override Future<bool> contains(Object? needle) async => false;
  @override Stream<List<int>> distinct([bool Function(List<int>, List<int>)? equals]) => const Stream.empty();
  @override Future<E> drain<E>([E? futureValue]) async => futureValue as E;
  @override Future<List<int>> elementAt(int index) async => throw RangeError.index(index, this);
  @override Future<bool> every(bool Function(List<int>) test) async => true;
  @override Stream<S> expand<S>(Iterable<S> Function(List<int>) convert) => const Stream.empty();
  @override Future<List<int>> get first async => Uint8List(0);
  @override Future<List<int>> firstWhere(bool Function(List<int>) test, {List<int> Function()? orElse}) async => orElse?.call() ?? Uint8List(0);
  @override Future<S> fold<S>(S initialValue, S Function(S, List<int>) combine) async => initialValue;
  @override Future forEach(void Function(List<int>) action) async {}
  @override Stream<List<int>> handleError(Function onError, {bool Function(dynamic)? test}) => const Stream.empty();
  @override bool get isBroadcast => false;
  @override Future<bool> get isEmpty async => true;
  @override Future<String> join([String separator = '']) async => '';
  @override Future<List<int>> get last async => Uint8List(0);
  @override Future<List<int>> lastWhere(bool Function(List<int>) test, {List<int> Function()? orElse}) async => orElse?.call() ?? Uint8List(0);
  @override Future<int> get length async => 0;
  @override Stream<S> map<S>(S Function(List<int>) convert) => const Stream.empty();
  @override Future pipe(StreamConsumer<List<int>> consumer) async => throw UnsupportedError('pipe');
  @override Future<List<int>> reduce(List<int> Function(List<int>, List<int>) combine) async => Uint8List(0);
  @override Future<List<int>> get single async => throw StateError('No elements');
  @override Future<List<int>> singleWhere(bool Function(List<int>) test, {List<int> Function()? orElse}) async => orElse?.call() ?? Uint8List(0);
  @override Stream<List<int>> skip(int count) => const Stream.empty();
  @override Stream<List<int>> skipWhile(bool Function(List<int>) test) => const Stream.empty();
  @override Stream<List<int>> take(int count) => const Stream.empty();
  @override Stream<List<int>> takeWhile(bool Function(List<int>) test) => const Stream.empty();
  @override Stream<List<int>> timeout(Duration timeLimit, {void Function(EventSink<List<int>>)? onTimeout}) => const Stream.empty();
  @override Future<List<List<int>>> toList() async => [];
  @override Future<Set<List<int>>> toSet() async => {};
  @override Stream<S> transform<S>(StreamTransformer<List<int>, S> transformer) => const Stream.empty();
  @override Stream<List<int>> where(bool Function(List<int>) test) => const Stream.empty();
}

class _TestHttpHeaders implements HttpHeaders {
  final Map<String, List<String>> _headers = {};

  @override void add(String name, Object value, {bool preserveHeaderCase = false}) {
    _headers.putIfAbsent(name, () => []).add(value.toString());
  }
  @override void set(String name, Object value, {bool preserveHeaderCase = false}) {
    _headers[name] = [value.toString()];
  }
  @override void remove(String name, Object value) => _headers[name]?.remove(value.toString());
  @override void removeAll(String name) => _headers.remove(name);
  @override List<String>? operator [](String name) => _headers[name];
  @override String? value(String name) => _headers[name]?.first;
  @override void forEach(void Function(String name, List<String> values) action) => _headers.forEach(action);
  @override void noFolding(String name) {}
  @override void clear() => _headers.clear();

  @override bool get chunkedTransferEncoding => false;
  @override set chunkedTransferEncoding(bool value) {}
  @override int get contentLength => 0;
  @override set contentLength(int value) {}
  @override ContentType? get contentType => null;
  @override set contentType(ContentType? value) {}
  @override DateTime? get date => null;
  @override set date(DateTime? value) {}
  @override DateTime? get expires => null;
  @override set expires(DateTime? value) {}
  @override String? get host => null;
  @override set host(String? value) {}
  @override DateTime? get ifModifiedSince => null;
  @override set ifModifiedSince(DateTime? value) {}
  @override bool get persistentConnection => false;
  @override set persistentConnection(bool value) {}
  @override int? get port => null;
  @override set port(int? value) {}
}
