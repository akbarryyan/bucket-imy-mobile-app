import 'package:flutter/material.dart';
import 'package:proyek_3/services/api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bucket App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF22C55E), // Primary green color
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF22C55E), // Green button
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50), // Full width
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25), // Rounded buttons
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF22C55E)),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1; // Start with register screen selected

  static const List<Widget> _screens = <Widget>[
    LoginScreen(),
    RegisterScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.login),
            label: 'Login',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            label: 'Register',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF22C55E),
        onTap: _onItemTapped,
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();
  String _message = '';
  bool _isLoading = false;
  bool _rememberMe = false;

  void _login() async {
    print('Login button clicked');
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _message = 'Please fill in all fields';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _message = '';
    });

    final response = await _apiService.login(
      _emailController.text,
      _passwordController.text,
    );

    setState(() {
      _isLoading = false;
      if (response['success']) {
        _message = response['message'];
        print('Login successful, navigating to dashboard');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      } else {
        _message = response['message'];
        print('Login failed: $_message');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: const Color(0xFF22C55E),
          child: SafeArea(
            child: Column(
              children: [
                // Content Area
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 180,
                        child: Center(
                          child: Image.asset(
                            'assets/images/ui-reg.png',
                            height: 250,
                          ),
                        ),
                      ),
                      // Form area
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Login To Your Account",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  labelText: 'Email Address',
                                  hintText: 'Enter your email',
                                  prefixIcon: Icon(Icons.email_outlined),
                                ),
                              ),
                              const SizedBox(height: 15),
                              TextField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  labelText: 'Password',
                                  hintText: 'Enter your password',
                                  prefixIcon: Icon(Icons.lock_outline),
                                ),
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: _rememberMe,
                                        onChanged: (value) {
                                          setState(() {
                                            _rememberMe = value ?? false;
                                          });
                                        },
                                        activeColor: const Color(0xFF22C55E),
                                      ),
                                      const Text('Remember Me'),
                                    ],
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: const Text(
                                      'Forgot Password?',
                                      style:
                                          TextStyle(color: Color(0xFF22C55E)),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              _isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : ElevatedButton(
                                      onPressed: _login,
                                      child: const Text(
                                        'LOGIN',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                              const SizedBox(height: 20),
                              if (_message.isNotEmpty)
                                Center(
                                  child: Text(
                                    _message,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ),
                              const Spacer(),
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("Don't have an account? "),
                                    GestureDetector(
                                      onTap: () {
                                        _MainScreenState? mainState =
                                            context.findAncestorStateOfType<
                                                _MainScreenState>();
                                        mainState?._onItemTapped(1);
                                      },
                                      child: const Text(
                                        'Register',
                                        style: TextStyle(
                                          color: Color(0xFF22C55E),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();
  String _message = '';
  bool _isLoading = false;

  void _register() async {
    print('Register button clicked');
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      setState(() {
        _message = 'Please fill in all fields';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _message = '';
    });

    final response = await _apiService.register(
      _nameController.text,
      _emailController.text,
      _passwordController.text,
    );

    setState(() {
      _isLoading = false;
      if (response['success']) {
        _message = response['message'];
        print('Register successful, navigating to login');
        _MainScreenState? mainState =
            context.findAncestorStateOfType<_MainScreenState>();
        mainState?._onItemTapped(0);
      } else {
        _message = response['message'] ?? 'Registration failed';
        if (response['errors'] != null) {
          _message = response['errors'].toString();
        }
        print('Register failed: $_message');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: const Color(0xFF22C55E),
          child: SafeArea(
            child: Column(
              children: [
                // Illustration
                SizedBox(
                  height: 180,
                  child: Center(
                    child: Image.asset(
                      'assets/images/ui-reg.png',
                      height: 250,
                    ),
                  ),
                ),

                // Form Container
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Create New Account",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Email Field
                        TextField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            hintText: 'name@',
                            labelText: 'Email',
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Name Field
                        TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            hintText: 'Name',
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Password Field
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: 'Password',
                          ),
                        ),

                        const SizedBox(height: 25),

                        // Register Button
                        _isLoading
                            ? const CircularProgressIndicator(
                                color: Color(0xFF22C55E))
                            : ElevatedButton(
                                onPressed: _register,
                                child: const Text(
                                  'REGISTER',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                        if (_message.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              _message,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),

                        const Spacer(),

                        // Login Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already have an account? ",
                              style: TextStyle(color: Colors.grey),
                            ),
                            GestureDetector(
                              onTap: () {
                                _MainScreenState? mainState =
                                    context.findAncestorStateOfType<
                                        _MainScreenState>();
                                mainState?._onItemTapped(0);
                              },
                              child: const Text(
                                "Login here",
                                style: TextStyle(
                                  color: Color(0xFF22C55E),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: const Color(0xFF22C55E),
      ),
      body: const Center(child: Text('Welcome to Dashboard!')),
    );
  }
}
