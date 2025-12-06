import 'package:flutter/material.dart';
import '../../services/users/user_service.dart';
import '../../core/auth/auth_storage.dart';
import '../../widgets/background_image.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _attendedChurchesController = TextEditingController();

  bool _isLoginMode = true;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _confirmPasswordController.dispose();
    _attendedChurchesController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _setLoading(true);

    try {
      final response = await UserService.login(
        _emailController.text.trim(),
        _passwordController.text,
      );
      _handleLoginResponse(response);
    } catch (e) {
      _showError('Error: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _handleLoginResponse(dynamic response) async {
    if (!mounted) return;

    if (response.authenticated) {
      await _saveAuthData(response);
      _showSuccess('Welcome back, ${response.user?.firstName ?? ''}!');
      Navigator.of(context).pop();
    } else {
      _showError(response.message);
    }
  }

  Future<void> _saveAuthData(dynamic response) async {
    if (response.token != null) {
      await AuthStorage.saveToken(response.token);
    }
    if (response.user != null) {
      await AuthStorage.saveUser(response.user);
    }
  }

  Future<void> _handleCreateAccount() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_passwordsMatch()) {
      _showError('Passwords do not match');
      return;
    }

    _setLoading(true);

    try {
      final attendedChurches = _parseAttendedChurches();
      final response = await UserService.createUser(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        attendedChurches: attendedChurches,
      );
      _handleCreateAccountResponse(response);
    } catch (e) {
      _showError('Error: $e');
    } finally {
      _setLoading(false);
    }
  }

  bool _passwordsMatch() {
    return _passwordController.text == _confirmPasswordController.text;
  }

  List<String>? _parseAttendedChurches() {
    final text = _attendedChurchesController.text.trim();
    if (text.isEmpty) {
      return null;
    }
    return text
        .split(',')
        .map((id) => id.trim())
        .where((id) => id.isNotEmpty)
        .toList();
  }

  void _handleCreateAccountResponse(dynamic response) {
    if (!mounted) return;

    if (response.created) {
      _showSuccess(response.message);
      _switchToLoginMode();
    } else {
      _showError(response.message);
    }
  }

  void _switchToLoginMode() {
    setState(() {
      _isLoginMode = true;
      _clearForm();
    });
  }

  void _setLoading(bool loading) {
    if (mounted) {
      setState(() {
        _isLoading = loading;
      });
    }
  }

  void _showSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _clearForm() {
    _emailController.clear();
    _passwordController.clear();
    _firstNameController.clear();
    _lastNameController.clear();
    _usernameController.clear();
    _confirmPasswordController.clear();
    _attendedChurchesController.clear();
  }

  void _toggleMode() {
    setState(() {
      _isLoginMode = !_isLoginMode;
      _clearForm();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundImage(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(_isLoginMode ? 'Login' : 'Create Account'),
          backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.9),
        ),
        body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              _buildHeaderIcon(),
              const SizedBox(height: 24),
              _buildHeaderText(),
              const SizedBox(height: 32),
              if (!_isLoginMode) _buildNameFields(),
              _buildEmailField(),
              const SizedBox(height: 16),
              _buildPasswordField(),
              if (!_isLoginMode) _buildConfirmPasswordField(),
              if (!_isLoginMode) _buildAttendedChurchesField(),
              const SizedBox(height: 32),
              _buildSubmitButton(),
              const SizedBox(height: 16),
              _buildToggleModeButton(),
            ],
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildHeaderIcon() {
    return Icon(
      _isLoginMode ? Icons.login : Icons.person_add,
      size: 64,
      color: Theme.of(context).colorScheme.primary,
    );
  }

  Widget _buildHeaderText() {
    return Column(
      children: [
        Text(
          _isLoginMode ? 'Welcome Back' : 'Create Your Account',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          _isLoginMode ? 'Sign in to continue' : 'Join our community today',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withOpacity(0.6),
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildNameFields() {
    return Column(
      children: [
        TextFormField(
          controller: _firstNameController,
          decoration: const InputDecoration(
            labelText: 'First Name',
            prefixIcon: Icon(Icons.person),
            border: OutlineInputBorder(),
          ),
          validator: (value) => _validateRequired(value, 'first name'),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _lastNameController,
          decoration: const InputDecoration(
            labelText: 'Last Name',
            prefixIcon: Icon(Icons.person_outline),
            border: OutlineInputBorder(),
          ),
          validator: (value) => _validateRequired(value, 'last name'),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _usernameController,
          decoration: const InputDecoration(
            labelText: 'Username',
            prefixIcon: Icon(Icons.alternate_email),
            border: OutlineInputBorder(),
          ),
          validator: _validateUsername,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your $fieldName';
    }
    return null;
  }

  String? _validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a username';
    }
    if (value.trim().length < 3) {
      return 'Username must be at least 3 characters';
    }
    return null;
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: const InputDecoration(
        labelText: 'Email',
        prefixIcon: Icon(Icons.email),
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: _validateEmail,
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }
    if (!value.contains('@')) {
      return 'Please enter a valid email';
    }
    return null;
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        border: const OutlineInputBorder(),
      ),
      obscureText: _obscurePassword,
      validator: _validatePassword,
    );
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (!_isLoginMode && value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  Widget _buildConfirmPasswordField() {
    return Column(
      children: [
        const SizedBox(height: 16),
        TextFormField(
          controller: _confirmPasswordController,
          decoration: InputDecoration(
            labelText: 'Confirm Password',
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword
                    ? Icons.visibility
                    : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),
            border: const OutlineInputBorder(),
          ),
          obscureText: _obscureConfirmPassword,
          validator: _validateConfirmPassword,
        ),
      ],
    );
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _isLoading
          ? null
          : (_isLoginMode ? _handleLogin : _handleCreateAccount),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: _isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Text(_isLoginMode ? 'Login' : 'Create Account'),
    );
  }

  Widget _buildAttendedChurchesField() {
    return Column(
      children: [
        const SizedBox(height: 16),
        TextFormField(
          controller: _attendedChurchesController,
          decoration: const InputDecoration(
            labelText: 'Attended Churches (Optional)',
            hintText: 'Enter church IDs separated by commas',
            prefixIcon: Icon(Icons.church),
            border: OutlineInputBorder(),
            helperText: 'Optional: Enter church IDs you have attended, separated by commas',
          ),
        ),
      ],
    );
  }

  Widget _buildToggleModeButton() {
    return TextButton(
      onPressed: _isLoading ? null : _toggleMode,
      child: Text(
        _isLoginMode
            ? 'Don\'t have an account? Create one'
            : 'Already have an account? Login',
      ),
    );
  }
}
