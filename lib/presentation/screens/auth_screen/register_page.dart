import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/logic/data/bloc/auth/auth_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // controllers
  final _usernameController = TextEditingController();
  final _nameController = TextEditingController();
  final _noTelpController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _passConfirmationController = TextEditingController();
  bool _hidePass = true;

  @override
  void dispose() {
    // TODO: implement dispose
    _usernameController.dispose();
    _nameController.dispose();
    _noTelpController.dispose();
    _emailController.dispose();
    _passController.dispose();
    _passConfirmationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: const Color(0xFFF8F9FA),
          elevation: 0),
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Buat Akunmu!",
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                    ],
                  ),

                  // sized box cuma buat margin, idk any alternatives
                  const SizedBox(
                    height: 20,
                  ),

                  // ini input text atau form
                  TextField(
                    style: GoogleFonts.montserrat(),
                    controller: _nameController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Nama Anda',
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  // ini input text atau form
                  TextField(
                    style: GoogleFonts.montserrat(),
                    controller: _noTelpController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Nomer Telepon',
                    ),
                  ),
                  //
                  const SizedBox(
                    height: 10,
                  ),
                  //

                  // ini input text atau form
                  TextField(
                    style: GoogleFonts.montserrat(),
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Username',
                    ),
                  ),

                  // ini input text atau form
                  TextField(
                    style: GoogleFonts.montserrat(),
                    controller: _emailController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Email',
                    ),
                  ),

                  //
                  const SizedBox(
                    height: 10,
                  ),
                  //

                  TextField(
                    style: GoogleFonts.montserrat(),
                    obscureText: _hidePass,
                    controller: _passController,
                    decoration: InputDecoration(
                        border: const UnderlineInputBorder(),
                        labelText: 'Sandi',
                        suffixIcon: IconButton(
                          icon: Icon(_hidePass
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _hidePass = !_hidePass;
                            });
                          },
                        )),
                  ),

                  TextField(
                    style: GoogleFonts.montserrat(),
                    obscureText: _hidePass,
                    controller: _passConfirmationController,
                    decoration: InputDecoration(
                        border: const UnderlineInputBorder(),
                        labelText: 'Konfirmasi Sandi',
                        suffixIcon: IconButton(
                          icon: Icon(_hidePass
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _hidePass = !_hidePass;
                            });
                          },
                        )),
                  ),

                  //
                  const SizedBox(
                    height: 30,
                  ),

                  //
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: GestureDetector(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            backgroundColor: const Color(0xFF151515)),
                        child: BlocConsumer<AuthBloc, AuthState>(
                            listener: (_, state) {
                              if (state is AuthRegistered){
                                Navigator.pop(context);
                              }
                            },
                            builder: (_, state) {
                              if (state is AuthLoading) {
                                return const CircularProgressIndicator(
                                  backgroundColor: Colors.black,
                                  color: Colors.white,
                                );
                              }
                              return Text("BUAT AKUN",
                                  style: GoogleFonts.montserrat(fontSize: 18,
                                  fontWeight: FontWeight.bold));
                            }),
                        onPressed: () async {
                          var data = {
                            "email": _emailController.text.trim(),
                            "username": _usernameController.text.trim(),
                            "name": _nameController.text.trim(),
                            "phone": _noTelpController.text.trim(),
                            "password": _passController.text.trim(),
                            "password_confirmation":
                                _passConfirmationController.text.trim(),
                          };
                          context.read<AuthBloc>().add(UserAuthRegister(data));
                        },
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "< Sudah memiliki akun? ",
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF979797)),
                      ),

                      //
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Login",
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
