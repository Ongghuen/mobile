import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/presentation/utils/default.dart';
import 'package:lottie/lottie.dart';

class IntroThreePage extends StatelessWidget {
  const IntroThreePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.height * 0.2),
      child: Column(
        children: [
          Expanded(child: Lottie.asset('assets/lottie/truck.json')),

          // text column
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 44),
            child: Column(
              children: [
                Text(
                  "Pengiriman Cepat",
                  style: GoogleFonts.montserrat(
                      fontSize: getAdaptiveTextSize(context, 20),
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: size.height * 0.03,),
                Text(
                  "Kami menyediakan jasa pengiriman barang atau perabotan bagi pembeli dengan estimasi cepat.",
                  style: GoogleFonts.montserrat(
                      fontSize: getAdaptiveTextSize(context, 14),
                      fontWeight: FontWeight.w200),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
