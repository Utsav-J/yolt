import 'package:flutter/material.dart';
import 'dart:ui';
import '../services/affirmation_service.dart';

class InfoCards extends StatefulWidget {
  const InfoCards({super.key});

  @override
  State<InfoCards> createState() => _InfoCardsState();
}

class _InfoCardsState extends State<InfoCards> {
  String _currentAffirmation =
      'I embrace the quiet strength within me to navigate the day with grace and purpose.';
  String _affirmationTimestamp = '';
  bool _isLoading = false;
  String? _lastError;

  @override
  void initState() {
    super.initState();
    _loadAffirmation();
  }

  Future<void> _loadAffirmation() async {
    final affirmationData = await AffirmationService.getAffirmation();
    final error = await AffirmationService.getLastError();

    setState(() {
      _currentAffirmation = affirmationData["affirmationText"];
      _affirmationTimestamp = affirmationData["timestamp"];
      _lastError = error;
    });
  }

  Future<void> _refreshAffirmation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Only allow refresh if last timestamp is at least 24 hours old
      DateTime? lastFetchUtc;
      if (_affirmationTimestamp.isNotEmpty) {
        try {
          String ts = _affirmationTimestamp.trim();
          if (ts.endsWith('Z') && ts.contains('+')) {
            ts = ts.substring(0, ts.length - 1);
          }
          lastFetchUtc = DateTime.parse(ts).toUtc();
        } catch (_) {
          lastFetchUtc = null;
        }
      }

      if (lastFetchUtc != null) {
        final nowUtc = DateTime.now().toUtc();
        final hoursSince = nowUtc.difference(lastFetchUtc).inHours;
        if (hoursSince < 24) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'You can refresh the affirmation once every 24 hours. (${24 - hoursSince}h remaining)',
              ),
              backgroundColor: Colors.grey[700],
              duration: const Duration(seconds: 3),
            ),
          );
          return;
        }
      }

      final newAffirmationData = await AffirmationService.refreshAffirmation();

      if (newAffirmationData != null) {
        setState(() {
          _currentAffirmation = newAffirmationData["affirmationText"];
          _affirmationTimestamp = newAffirmationData["timestamp"];
          _lastError = null; // Clear error on success
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Affirmation refreshed successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        // Get the error message for user feedback
        final error = await AffirmationService.getLastError();
        final userFriendlyError =
            AffirmationService.getUserFriendlyErrorMessage(
              error ?? 'Unknown error',
            );

        setState(() {
          _lastError = error;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(userFriendlyError),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'Dismiss',
              textColor: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
      }
    } catch (e) {
      final userFriendlyError = AffirmationService.getUserFriendlyErrorMessage(
        e.toString(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(userFriendlyError),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
          action: SnackBarAction(
            label: 'Dismiss',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: _refreshAffirmation,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withValues(alpha: 0.25),
                        Colors.white.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(-1, -1),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _currentAffirmation,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black.withValues(alpha: 0.75),
                                height: 1.4,
                              ),
                            ),
                          ),
                          if (_isLoading)
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF8B5CF6),
                                ),
                              ),
                            )
                          else
                            Icon(
                              Icons.refresh,
                              size: 20,
                              color: Colors.black.withValues(alpha: 0.6),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Daily Affirmation',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black.withValues(alpha: 0.6),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            _lastError != null
                                ? 'Tap to retry'
                                : 'Tap to refresh',
                            style: TextStyle(
                              fontSize: 10,
                              color: _lastError != null
                                  ? Colors.orange[700]
                                  : Colors.black.withValues(alpha: 0.5),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
