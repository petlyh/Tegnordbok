import "dart:io";

import "package:expandable_text/expandable_text.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:http/http.dart";

class RiverpodLoaderWidget<T> extends StatelessWidget {
  const RiverpodLoaderWidget(
      {super.key,
      required this.asyncValue,
      required this.handler,
      this.onRetry});

  final AsyncValue<T> asyncValue;
  final Widget Function(T data) handler;
  final Function()? onRetry;

  @override
  Widget build(BuildContext context) {
    return switch (asyncValue) {
      AsyncData(:final value) => handler(value),
      AsyncError(:final error) => ErrorIndicator(
          error,
          onRetry: onRetry,
        ),
      _ => Center(
          child: Container(
              margin: const EdgeInsets.all(20.0),
              child: const CircularProgressIndicator()),
        ),
    };
  }
}

class LoaderWidget<T> extends StatefulWidget {
  const LoaderWidget(
      {super.key,
      required this.onLoad,
      required this.handler,
      this.placeholder = const Text("")});

  final Future<T> Function() onLoad;
  final Widget Function(T data) handler;
  final Widget placeholder;

  @override
  State<LoaderWidget<T>> createState() => _LoaderWidgetState<T>();
}

class _LoaderWidgetState<T> extends State<LoaderWidget<T>> {
  late Future<T> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.onLoad();
  }

  void _retry() {
    setState(() {
      _future = widget.onLoad();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Container(
                  margin: const EdgeInsets.all(20.0),
                  child: const CircularProgressIndicator()),
            );
          }

          if (snapshot.connectionState == ConnectionState.none) {
            return widget.placeholder;
          }

          if (snapshot.hasError) {
            return ErrorIndicator(
              snapshot.error!,
              stackTrace: snapshot.stackTrace,
              onRetry: _retry,
            );
          }

          if (snapshot.hasData && snapshot.data != null) {
            return widget.handler(snapshot.data as T);
          }

          throw AssertionError();
        });
  }
}

class ErrorIndicator extends StatelessWidget {
  const ErrorIndicator(this.error, {super.key, this.stackTrace, this.onRetry});

  final Object error;
  final Function()? onRetry;
  final StackTrace? stackTrace;

  String get _userMessage {
    if (error is SocketException || error is ClientException) {
      return "A network error occured.\nCheck your connection.";
    }

    return "An error occured";
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_userMessage, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            ElevatedButton(
              child: const Text("Show Error"),
              onPressed: () =>
                  showErrorInfoDialog(context, error, stackTrace: stackTrace),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 4),
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text("Retry"),
                onPressed: onRetry,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

void showErrorInfoDialog(BuildContext context, Object error,
        {StackTrace? stackTrace}) =>
    showDialog(
        context: context,
        builder: (context) => ErrorInfoDialog(error, stackTrace: stackTrace));

class ErrorInfoDialog extends StatelessWidget {
  const ErrorInfoDialog(this.error, {super.key, this.stackTrace});

  final Object error;
  final StackTrace? stackTrace;

  String get _errorType => error.runtimeType.toString();
  String get _errorMessage => error.toString();

  Widget _infoText(String title, String info, {TextStyle? style}) {
    return Text.rich(
      TextSpan(
        style: style,
        children: [
          TextSpan(
              text: title, style: const TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: info),
        ],
      ),
    );
  }

  void _copyError(BuildContext context) {
    final copyText =
        "Type: $_errorType  \nMessage: $_errorMessage  \nStack trace:\n```\n${stackTrace.toString()}```";

    Clipboard.setData(ClipboardData(text: copyText)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Copied error info")),
      );
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding:
          const EdgeInsets.only(top: 28, bottom: 12, left: 28, right: 28),
      contentPadding: const EdgeInsets.symmetric(horizontal: 28),
      title: const Text("Error Info", style: TextStyle(fontSize: 20)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoText("Type: ", _errorType),
            _infoText("Message: ", _errorMessage),
            if (stackTrace != null) ...[
              _infoText("Stack trace: ", ""),
              ExpandableText(
                stackTrace.toString(),
                expandText: "Show",
                collapseText: "Hide",
                maxLines: 1,
                linkColor: Theme.of(context).colorScheme.primary,
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text("Copy"),
          onPressed: () => _copyError(context),
        ),
        TextButton(
          child: const Text("Close"),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
