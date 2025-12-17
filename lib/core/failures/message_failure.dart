class MessageFailure {
  final String message;
  final dynamic error;
  final StackTrace? stackTrace;

  MessageFailure(this.message, {this.error, this.stackTrace});

  @override
  String toString() => 'MessageFailure: $message, Error: $error';
}
