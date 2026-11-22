import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _pinController = TextEditingController();

  bool _cargando = true;
  bool _cuentaExistente = false;
  String _nombreGuardado = '';
  String _pinGuardado = '';

  @override
  void initState() {
    super.initState();
    _verificarPerfilLocal();
  }

  Future<void> _verificarPerfilLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final pin = prefs.getString('productor_pin');
    final nombre = prefs.getString('productor_nombre');

    setState(() {
      if (pin != null && pin.isNotEmpty) {
        _cuentaExistente = true;
        _pinGuardado = pin;
        _nombreGuardado = nombre ?? 'Productor';
      }
      _cargando = false;
    });
  }

  Future<void> _ingresar() async {
    if (!_formKey.currentState!.validate()) return;

    final prefs = await SharedPreferences.getInstance();

    if (!_cuentaExistente) {
      // Primer ingreso: guarda el perfil y PIN localmente
      await prefs.setString('productor_nombre', _nombreController.text.trim());
      await prefs.setString('productor_pin', _pinController.text.trim());
    } else {
      // Ingreso posterior: valida el PIN guardado
      if (_pinController.text.trim() != _pinGuardado) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PIN incorrecto. Intenta nuevamente.'),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }
    }

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircleAvatar(
                        radius: 36,
                        backgroundColor: Color(0xFF2E7D32),
                        child: Icon(Icons.eco, size: 40, color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'AgroRegistro',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1B5E20),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _cuentaExistente
                            ? 'Hola de nuevo, $_nombreGuardado'
                            : 'Configura tu acceso local de productor',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 24),
                      if (!_cuentaExistente) ...[
                        TextFormField(
                          controller: _nombreController,
                          decoration: const InputDecoration(
                            labelText: 'Nombre del productor o finca',
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Ingresa tu nombre';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                      TextFormField(
                        controller: _pinController,
                        obscureText: true,
                        maxLength: 4,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: _cuentaExistente
                              ? 'Ingresa tu PIN de 4 dígitos'
                              : 'Crea un PIN de 4 dígitos',
                          prefixIcon: const Icon(Icons.lock),
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().length != 4) {
                            return 'El PIN debe tener exactamente 4 dígitos';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: FilledButton.icon(
                          onPressed: _ingresar,
                          icon: const Icon(Icons.login),
                          label: Text(
                            _cuentaExistente
                                ? 'Ingresar al Inventario'
                                : 'Guardar Acceso e Ingresar',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
