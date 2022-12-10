import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/logic/data/bloc/auth/auth_bloc.dart';
import 'package:mobile/logic/data/bloc/detail_transaction/detail_transaction_bloc.dart';
import 'package:mobile/logic/data/bloc/product/product_bloc.dart';
import 'package:mobile/logic/data/bloc/transaction/transaction_bloc.dart';
import 'package:mobile/logic/data/bloc/wishlist/wishlist_bloc.dart';
import 'package:mobile/presentation/utils/default.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.grey[800],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Let's order fresh items for you
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              "Checkout",
              style: GoogleFonts.montserrat(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // list view of cart
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: BlocBuilder<DetailTransactionBloc, DetailTransactionState>(
                builder: (context, state) {
                  if (state is DetailTransactionLoaded) {
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: state.data.results!.length,
                      itemBuilder: (context, index) {
                        return BlocBuilder<ProductBloc, ProductState>(
                            builder: (_, pstate) {
                          if (pstate is ProductLoaded) {
                            var product = pstate.productModel.results!.where(
                                (element) =>
                                    element.id ==
                                    state
                                        .data.results![index].pivot!.productId);

                            return InkWell(
                              child: Card(
                                child: Container(
                                  margin: EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      product.first.image == null
                                          ? SizedBox(
                                              width: 50,
                                              child: Icon(Icons.chair),
                                            )
                                          : SizedBox(
                                              width: 50,
                                              child: Image.network(
                                                "${apiUrlStorage}${product.first.image}",
                                                fit: BoxFit.fill,
                                                // Better way to load images from network flutter
                                                // https://stackoverflow.com/questions/53577962/better-way-to-load-images-from-network-flutter
                                                loadingBuilder:
                                                    (BuildContext context,
                                                        Widget child,
                                                        ImageChunkEvent?
                                                            loadingProgress) {
                                                  if (loadingProgress == null)
                                                    return child;
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      value: loadingProgress
                                                                  .expectedTotalBytes !=
                                                              null
                                                          ? loadingProgress
                                                                  .cumulativeBytesLoaded /
                                                              loadingProgress
                                                                  .expectedTotalBytes!
                                                          : null,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                      Column(
                                        children: <Widget>[
                                          Text(
                                              "${state.data.results![index].name}"),
                                          Text(
                                              "Rp.${state.data.results![index].harga},00"),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                          return CircularProgressIndicator();
                        });
                      },
                    );
                  }
                  return CircularProgressIndicator();
                },
              ),
            ),
          ),

          // total amount + pay now

          GestureDetector(
            onTap: () {
              final state = context.read<AuthBloc>().state;
              if (state is AuthLoaded) {
                context
                    .read<TransactionBloc>()
                    .add(CheckoutTransactionLists(state.userModel.token));
                context.read<DetailTransactionBloc>().add(
                    GetOngoingDetailTransactionList(state.userModel.token));
                Navigator.pop(context);
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.black,
                ),
                padding: const EdgeInsets.all(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'CONFIRM PEMBAYARAN???',
                      style: TextStyle(color: Colors.white),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(28),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: const [
                          Text(
                            'LETSGOO',
                            style: TextStyle(color: Colors.white),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),

                    // pay now
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
