import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hackathon/back_end/auth_service.dart';
import 'package:hackathon/front_end/theme.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isSignUp = false;
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submitEmailAuth() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      if (_isSignUp) {
        await _authService.signUpWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          displayName: _nameController.text.trim(),
        );
      } else {
        await _authService.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = _getReadableAuthError(e);
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An unexpected error occurred: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _submitGoogleAuth() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _authService.signInWithGoogle();
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = _getReadableAuthError(e);
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to sign in with Google: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _getReadableAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email address. Switch to "Register" above to create an account!';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password. Please verify your details.';
      case 'email-already-in-use':
        return 'An account already exists for this email address. Switch to "Sign In"!';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'popup-closed-by-user':
        return 'Google Sign-In popup was closed before completing.';
      case 'operation-not-allowed':
        return 'This authentication provider is disabled in your Firebase console.';
      default:
        return e.message ?? 'Authentication failed (${e.code}).';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.contentBg,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 440),
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: AppColors.contentSurface,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.contentDivider),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Header Branding ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.sidebarBg,
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: const Center(
                          child: Text(
                            'C',
                            style: TextStyle(
                              color: AppColors.accent,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        'CAMPUS OS',
                        style: AppTypography.h3.copyWith(
                          letterSpacing: 2.0,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    _isSignUp ? 'Create your Campus Account' : 'Welcome back to Campus',
                    textAlign: TextAlign.center,
                    style: AppTypography.h4.copyWith(fontSize: 20),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _isSignUp
                        ? 'Sign up to manage schedules, assignments, and campus events.'
                        : 'Sign in to access your personal dashboard.',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodySmall,
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // ── Error Banner ──
                  if (_errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red.shade700, size: 20),
                          const SizedBox(width: AppSpacing.xs),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: AppTypography.bodySmall.copyWith(
                                color: Colors.red.shade800,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],

                  // ── Toggle Switcher ──
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.tableHeaderBg,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => setState(() {
                              _isSignUp = false;
                              _errorMessage = null;
                            }),
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: !_isSignUp ? AppColors.contentSurface : Colors.transparent,
                                borderRadius: BorderRadius.circular(AppRadius.sm),
                                boxShadow: !_isSignUp
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.04),
                                          blurRadius: 4,
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Text(
                                'Sign In',
                                textAlign: TextAlign.center,
                                style: AppTypography.bodySmall.copyWith(
                                  fontWeight: !_isSignUp ? FontWeight.bold : FontWeight.w500,
                                  color: !_isSignUp ? AppColors.contentText : AppColors.contentTextMuted,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () => setState(() {
                              _isSignUp = true;
                              _errorMessage = null;
                            }),
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: _isSignUp ? AppColors.contentSurface : Colors.transparent,
                                borderRadius: BorderRadius.circular(AppRadius.sm),
                                boxShadow: _isSignUp
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.04),
                                          blurRadius: 4,
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Text(
                                'Register',
                                textAlign: TextAlign.center,
                                style: AppTypography.bodySmall.copyWith(
                                  fontWeight: _isSignUp ? FontWeight.bold : FontWeight.w500,
                                  color: _isSignUp ? AppColors.contentText : AppColors.contentTextMuted,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // ── Full Name Field (Sign Up Only) ──
                  if (_isSignUp) ...[
                    Text('Full Name', style: AppTypography.caption),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: 'e.g. Alex Rivera',
                        prefixIcon: Icon(Icons.person_outline, size: 20),
                      ),
                      validator: (value) {
                        if (_isSignUp && (value == null || value.trim().isEmpty)) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],

                  // ── Email Field ──
                  Text('Gmail / Email Address', style: AppTypography.caption),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'student@campus.edu or name@gmail.com',
                      prefixIcon: Icon(Icons.email_outlined, size: 20),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@') || !value.contains('.')) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // ── Password Field ──
                  Text('Password', style: AppTypography.caption),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: '••••••••',
                      prefixIcon: const Icon(Icons.lock_outline, size: 20),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          size: 20,
                        ),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (_isSignUp && value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // ── Main Action Button ──
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submitEmailAuth,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: AppColors.accentText,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.contentText),
                            ),
                          )
                        : Text(
                            _isSignUp ? 'Create Account' : 'Sign In',
                            style: AppTypography.body.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.accentText,
                            ),
                          ),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // ── Divider ──
                  Row(
                    children: [
                      const Expanded(child: Divider(color: AppColors.contentDivider)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                        child: Text(
                          'OR',
                          style: AppTypography.caption.copyWith(color: AppColors.contentTextMuted),
                        ),
                      ),
                      const Expanded(child: Divider(color: AppColors.contentDivider)),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // ── Google Sign In Button ──
                  OutlinedButton.icon(
                    onPressed: _isLoading ? null : _submitGoogleAuth,
                    icon: Image.network(
                      'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
                      width: 18,
                      height: 18,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.g_mobiledata, size: 24, color: AppColors.contentText),
                    ),
                    label: Text(
                      'Continue with Google / Gmail',
                      style: AppTypography.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.contentText,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: AppColors.contentDivider),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
