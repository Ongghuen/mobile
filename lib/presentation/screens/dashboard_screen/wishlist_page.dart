import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/logic/data/bloc/auth/auth_bloc.dart';
import 'package:mobile/logic/data/bloc/product/product_bloc.dart';
import 'package:mobile/logic/data/bloc/wishlist/wishlist_bloc.dart';
import 'package:mobile/presentation/screens/product_screen/detail_product_page.dart';
import 'package:mobile/presentation/utils/default.dart';

void main(List<String> args) {
  runApp(WishlistPage());
}

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
              "Wishlist",
              style: GoogleFonts.montserrat(
                fontSize: getAdaptiveTextSize(context, 22),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          SizedBox(height: 20,),

          // list view of wishlist
          Expanded(
            child: BlocBuilder<WishlistBloc, WishlistState>(
              builder: (context, state) {
                if (state is WishlistInitial) {
                  return const Text("LOADING MAZ");
                } else if (state is WishlistLoaded) {
                  return state.data.results!.isEmpty
                      ? Center(
                          child: SizedBox(
                            width: size.width * 0.7,
                            child: Text("Ayooo cari furnitur favoritmu di "
                                "katalog kami!", style:GoogleFonts.montserrat
                              (fontSize: getAdaptiveTextSize(context, 14),
                                fontWeight:
                            FontWeight.w300),
                              textAlign: TextAlign.center,),
                          ))
                      : ListView.builder(
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
                                        state.data.results![index].pivot!
                                            .productId);

                                return Container(
                                  decoration: productBox(),
                                  margin:
                                      EdgeInsets.symmetric(horizontal:
                                      size.width * 0.03, vertical: size
                                          .height * 0.01),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => DetailProduct(
                                                  productId: product.first.id!
                                                      .toInt())));
                                    },
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              product.first.image == null
                                                  ? ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      child: Container(
                                                        height:
                                                        size
                                                            .height * 0.10,
                                                        width:
                                                        size
                                                            .width * 0.2,
                                                        child: Icon(
                                                          Icons.inventory,
                                                        ),
                                                      ),
                                                    )
                                                  : ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      child: Hero(
                                                        tag: 'product',
                                                        child: Image.network(
                                                          "${apiUrlStorage}/${product.first.image}",
                                                          fit: BoxFit.cover,
                                                          height:
                                                          size
                                                              .height * 0.10,
                                                          width:
                                                          size
                                                              .width * 0.2,
                                                          // Better way to load images from network flutter
                                                          // https://stackoverflow.com/questions/53577962/better-way-to-load-images-from-network-flutter
                                                          loadingBuilder: (BuildContext
                                                                  context,
                                                              Widget child,
                                                              ImageChunkEvent?
                                                                  loadingProgress) {
                                                            if (loadingProgress ==
                                                                null) return child;
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
                                                    ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${truncateWithEllipsis
                                                      (12, "${product.first
                                                        .name}")}",
                                                    style:
                                                        GoogleFonts.montserrat(
                                                          fontSize:
                                                          getAdaptiveTextSize(context, 12),
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  ),
                                                  Text(
                                                    "${truncateWithEllipsis(20, product.first.desc.toString())}",
                                                    style:
                                                        GoogleFonts.montserrat(
                                                          fontSize:
                                                          getAdaptiveTextSize(context, 12),
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                  ),
                                                  Text(
                                                      "${rupiahConvert
                                                          .format(product
                                                          .first
                                                          .harga)}", style:
                                                  GoogleFonts.montserrat(
                                                      fontSize:
                                                      getAdaptiveTextSize(context, 12),
                                                      fontWeight:
                                                      FontWeight
                                                          .normal)),
                                                ],
                                              ),
                                              BlocBuilder<AuthBloc, AuthState>(
                                                builder: (context, state) {
                                                  if (state is AuthLoaded) {
                                                    return IconButton(
                                                      icon: Icon(Icons
                                                          .favorite_outlined),
                                                      onPressed: () {
                                                        String productId = product
                                                            .first.id
                                                            .toString();

                                                        context
                                                            .read<WishlistBloc>()
                                                            .add(DeleteProductFromWishlist(
                                                                productId,
                                                                state.userModel
                                                                    .token
                                                                    .toString()));
                                                      },
                                                    );
                                                  }
                                                  return Icon(Icons
                                                      .heart_broken_outlined);
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                              return loading();
                            });
                          },
                        );
                }
                return loading();
              },
            ),
          ),
        ],
      ),
    );
  }
}
