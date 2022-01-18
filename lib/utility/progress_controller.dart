import 'dart:async';
import 'package:meta/meta.dart';

class ProgressController {
  ProgressController({@required this.duration})
      : assert(duration != null),
        tickPeriod = _calculateTickPeriod(duration);

  static const double smoothnessConstant = 250;

  final Duration duration;
  final Duration tickPeriod;

  Timer _timer;
  Timer _periodicTimer;

  Stream<void> get progressStream => _progressController.stream;
  final StreamController<void> _progressController =
      StreamController<void>.broadcast();

  Stream<void> get timeoutStream => _timeoutController.stream;
  final StreamController<void> _timeoutController =
      StreamController<void>.broadcast();

  double get progress => _progress;
  double _progress = 0;

  void start() {
    _timer = Timer(duration, () {
      _cancelTimers();
      _setProgressAndNotify(1);
      _timeoutController.add(null);
    });

    _periodicTimer = Timer.periodic(
      tickPeriod,
      (Timer timer) {
        final double progress = _calculateProgress(timer);
        _setProgressAndNotify(progress);
      },
    );
  }

  void restart() {
    _cancelTimers();
    start();
  }

  Future<void> dispose() async {
    await _cancelStreams();
    _cancelTimers();
  }

  double _calculateProgress(Timer timer) {
    final double progress = timer.tick / smoothnessConstant;

    if (progress > 1) {
      return 1;
    }

    if (progress < 0) {
      return 0;
    }
    return progress;
  }

  void _setProgressAndNotify(double value) {
    _progress = value;
    _progressController.add(null);
  }

  Future<void> _cancelStreams() async {
    if (!_progressController.isClosed) {
      await _progressController.close();
    }

    if (!_timeoutController.isClosed) {
      await _timeoutController.close();
    }
  }

  void _cancelTimers() {
    if (_timer?.isActive == true) {
      _timer.cancel();
    }
    if (_periodicTimer?.isActive == true) {
      _periodicTimer.cancel();
    }
  }

  static Duration _calculateTickPeriod(Duration duration) {
    final double tickPeriodMs = duration.inMilliseconds / smoothnessConstant;
    return Duration(milliseconds: tickPeriodMs.toInt());
  }
}
