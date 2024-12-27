import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/security_provider.dart';
import 'home_screen.dart';

class PinScreen extends StatefulWidget {
  final bool isSetup;
  const PinScreen({Key? key, this.isSetup = false}) : super(key: key);

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  final TextEditingController _pinController = TextEditingController();
  String _errorText = '';
  bool _isLoading = false;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _verifyPin() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _errorText = '';
    });

    try {
      final securityProvider =
          Provider.of<SecurityProvider>(context, listen: false);

      if (_pinController.text.isEmpty) {
        setState(() {
          _errorText = 'Please enter PIN';
        });
        return;
      }

      final isCorrect = await securityProvider.authenticateUser();

      if (isCorrect) {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        setState(() {
          _errorText = 'Authentication failed';
        });
      }
    } catch (e) {
      setState(() {
        _errorText = 'Error: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _setupPin() async {
    if (_isLoading) return;

    if (_pinController.text.length < 4) {
      setState(() {
        _errorText = 'PIN must be at least 4 digits';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = '';
    });

    try {
      final securityProvider =
          Provider.of<SecurityProvider>(context, listen: false);
      await securityProvider.toggleAppLock(true);

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } catch (e) {
      setState(() {
        _errorText = 'Error: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isSetup ? 'Setup PIN' : 'Enter PIN'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _pinController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              obscureText: true,
              decoration: InputDecoration(
                labelText: widget.isSetup ? 'Create PIN' : 'Enter PIN',
                errorText: _errorText.isEmpty ? null : _errorText,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : (widget.isSetup ? _setupPin : _verifyPin),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(widget.isSetup ? 'Set PIN' : 'Verify'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
