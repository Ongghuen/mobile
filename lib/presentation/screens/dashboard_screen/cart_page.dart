import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/logic/data/bloc/auth/auth_bloc.dart';
import 'package:mobile/logic/data/bloc/detail_transaction/detail_transaction_bloc.dart';
import 'package:mobile/logic/data/bloc/product/product_bloc.dart';
import 'package:mobile/presentation/screens/transaction_screen/checkout_page.dart';
import 'package:mobile/presentation/screens/product_screen/detail_product_page.dart';
import 'package:mobile/presentation/utils/components/snackbar.dart';
import 'package:mobile/presentation/utils/default.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  void reloadBlocs() {
    final state = context.read<AuthBloc>().state;
    if (state is AuthLoaded) {
      context.read<AuthBloc>().add(UserAuthCheckToken(state.userModel.token));
      // get products
      context.read<ProductBloc>().add(GetProductList());
      // get wishlists
      context.read<DetailTransactionBloc>().add(
          GetOngoingDetailTransactionList(state.userModel.token.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
              "Keranjang",
              style: GoogleFonts.montserrat(
                fontSize: getAdaptiveTextSize(context, 22),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          SizedBox(
            height: 20,
          ),

          // list view of cart
          Expanded(
            child: RefreshIndicator(
              color: Colors.black,
              onRefresh: () async => reloadBlocs(),
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics()),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: BlocBuilder<DetailTransactionBloc,
                      DetailTransactionState>(
                    builder: (context, state) {
                      if (state is DetailTransactionLoaded) {
                        var checkout = state.data.results!;
                        return checkout.isEmpty
                            ? Center(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: size.height * 0.3,
                                    ),
                                    Text(
                                      'Ayoo beli '
                                      'furniturmu di catalog!',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.montserrat(
                                          fontSize:
                                              getAdaptiveTextSize(context, 14),
                                          fontWeight: FontWeight.w300),
                                    )
                                  ],
                                ),
                              )
                            : ListView.builder(
                                scrollDirection: Axis.vertical,
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: checkout.length,
                                itemBuilder: (context, index) {
                                  return BlocBuilder<ProductBloc, ProductState>(
                                      builder: (_, pstate) {
                                    if (pstate is ProductLoaded) {
                                      var product = pstate.productModel.results!
                                          .where((element) =>
                                              element.id ==
                                              state.data.results![index].pivot!
                                                  .productId);

                                      return Slidable(
                                        endActionPane: ActionPane(
                                          motion: ScrollMotion(),
                                          children: [
                                            SlidableAction(
                                              onPressed: (BuildContext
                                                      context) =>
                                                  deleteItem(product.first.id),
                                              backgroundColor:
                                                  Color(0xFFb50000),
                                              foregroundColor: Colors.white,
                                              icon: Icons
                                                  .playlist_remove_outlined,
                                              label: 'Hapus',
                                            ),
                                          ],
                                        ),
                                        child: Container(
                                          decoration: productBox(),
                                          margin: const EdgeInsets.only(
                                              bottom: 12, right: 12),
                                          child: Padding(
                                            padding: const EdgeInsets.all(14.0),
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            DetailProduct(
                                                                productId: product
                                                                    .first.id!
                                                                    .toInt())));
                                              },
                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    children: [
                                                      product.first.image ==
                                                              null
                                                          ? ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15),
                                                              child: Container(
                                                                height:
                                                                    size.height *
                                                                        0.15,
                                                                width:
                                                                    size.width *
                                                                        0.3,
                                                                child: Icon(
                                                                  Icons
                                                                      .inventory,
                                                                ),
                                                              ),
                                                            )
                                                          : ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15),
                                                              child:
                                                                  Hero(
                                                                    tag: 'product',
                                                                    child: Image.network(
                                                                                                                                  "${apiUrlStorage}/${product.first.image}",
                                                                                                                                  fit: BoxFit
                                                                      .cover,
                                                                                                                                  height:
                                                                      size.height *
                                                                          0.15,
                                                                                                                                  width:
                                                                      size.width *
                                                                          0.3,
                                                                                                                                  // Better way to load images from network flutter
                                                                                                                                  // https://stackoverflow.com/questions/53577962/better-way-to-load-images-from-network-flutter
                                                                                                                                  loadingBuilder: (BuildContext
                                                                          context,
                                                                      Widget
                                                                          child,
                                                                      ImageChunkEvent?
                                                                          loadingProgress) {
                                                                    if (loadingProgress ==
                                                                        null)
                                                                      return child;
                                                                    return Center(
                                                                      child:
                                                                          CircularProgressIndicator(
                                                                        value: loadingProgress.expectedTotalBytes !=
                                                                                null
                                                                            ? loadingProgress.cumulativeBytesLoaded /
                                                                                loadingProgress.expectedTotalBytes!
                                                                            : null,
                                                                      ),
                                                                    );
                                                                                                                                  },
                                                                                                                                ),
                                                                  ),
                                                            ),
                                                      SizedBox(
                                                        width: 20,
                                                      ),
                                                      Expanded(
                                                        child: SizedBox(
                                                          height: 100,
                                                          width: 150,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                "${truncateWithEllipsis(14, "${product.first.name}")}",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: GoogleFonts.montserrat(
                                                                    fontSize:
                                                                        getAdaptiveTextSize(
                                                                            context,
                                                                            12),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              Text(
                                                                  "${truncateWithEllipsis(14, "${rupiahConvert.format(product.first.harga)}")}",
                                                                  style: GoogleFonts.montserrat(
                                                                      fontSize: getAdaptiveTextSize(
                                                                          context,
                                                                          12),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400)),
                                                              Container(
                                                                width: 150,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    IconButton(
                                                                        onPressed:
                                                                            () {
                                                                          var data =
                                                                              {
                                                                            "produc"
                                                                                "t_"
                                                                                "id"
                                                                                "": "${state.data.results![index].id}",
                                                                            "qty":
                                                                                "${checkout[index].pivot!.qty != 1 ? checkout[index].pivot!.qty - 1 : deleteItem(state.data.results![index].id)}",
                                                                            "sub_total":
                                                                                "${checkout[index].harga * (checkout[index].pivot!.qty - 1)}"
                                                                          };
                                                                          final astate = context
                                                                              .read<AuthBloc>()
                                                                              .state;
                                                                          if (astate
                                                                              is AuthLoaded) {
                                                                            print(state.data.results![index].id);
                                                                            checkout[index].pivot!.qty != 1
                                                                                ? context.read<DetailTransactionBloc>().add(SubstractQTYProductToDetailTransactionList(data, astate.userModel.token))
                                                                                : "";
                                                                          }
                                                                        },
                                                                        icon: Icon(
                                                                            Icons.remove_circle_outline)),
                                                                    Text(state.data.results![index].pivot!.qty ==
                                                                            null
                                                                        ? "0"
                                                                        : state
                                                                            .data
                                                                            .results![index]
                                                                            .pivot!
                                                                            .qty
                                                                            .toString()),
                                                                    IconButton(
                                                                        onPressed:
                                                                            () {
                                                                          var data =
                                                                              {
                                                                            "produc"
                                                                                "t_"
                                                                                "id"
                                                                                "": "${state.data.results![index].id}",
                                                                            "qty":
                                                                                "${checkout[index].pivot!.qty + 1}",
                                                                            "sub_total":
                                                                                "${checkout[index].harga * (checkout[index].pivot!.qty + 1)}"
                                                                          };
                                                                          final astate = context
                                                                              .read<AuthBloc>()
                                                                              .state;
                                                                          if (astate
                                                                              is AuthLoaded) {
                                                                            print(state.data.results![index].id);
                                                                            context.read<DetailTransactionBloc>().add(AddQTYProductToDetailTransactionList(data,
                                                                                astate.userModel.token));
                                                                          }
                                                                        },
                                                                        icon: Icon(
                                                                            Icons.add_circle_outline)),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    return SizedBox();
                                  });
                                },
                              );
                      }
                      return Column(
                        children: [
                          SizedBox(
                            height: size.height * 0.5,
                            child: loading(),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),

          // total amount + pay now

          Padding(
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // total price
                      Text(
                        'CHECKOUT',
                        style: GoogleFonts.montserrat(
                          fontSize: getAdaptiveTextSize(context, 18),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  // pay now
                  BlocConsumer<DetailTransactionBloc, DetailTransactionState>(
                      listener: (context, state) {
                    if (state is DetailTransactionError) {
                      showSnackbar(context, "${state.msg}");
                    }
                  }, builder: (context, state) {
                    if (state is DetailTransactionLoaded) {
                      return state.data.results!.isEmpty
                          ? Text(
                              ':| Tidak ada item',
                              style:
                                  GoogleFonts.montserrat(color: Colors.white),
                            )
                          : GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CheckoutPage()));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    Text(
                                      'Bayar',
                                      style: GoogleFonts.montserrat(
                                          color: Colors.white),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            );
                    }
                    return Text("nope");
                  })
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  deleteItem(id) {
    var product_id = {"product_id": id.toString()};

    final astate = context.read<AuthBloc>().state;
    if (astate is AuthLoaded) {
      context.read<DetailTransactionBloc>().add(
          DeleteProductToDetailTransactionList(
              product_id, astate.userModel.token));
    }
    return "0";
  }
}
