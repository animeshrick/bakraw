import 'package:bakraw/GlobalWidget/GlobalWidget.dart';
import 'package:bakraw/model/favouritemodel.dart';
import 'package:bakraw/provider/favouriteproductprovider.dart';
import 'package:bakraw/screen/dashboaruderprofile.dart';
import 'package:bakraw/utils/GroceryColors.dart';
import 'package:bakraw/utils/GroceryConstant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserFavouriteList extends StatefulWidget {
  @override
  _UserFavouriteListState createState() => _UserFavouriteListState();
}

class _UserFavouriteListState extends State<UserFavouriteList> {
  List<Datas> mFavouriteList = [];
  String userid, email, apikey;
  bool favinit = true;

  @override
  void initState() {}

  Future setUser() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      email = prefs.getString('email');
      if (email.isNotEmpty) {
        userid = prefs.getString('id');
        apikey = prefs.getString('apikey');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    setUser().then((value) {
      if (favinit) {
        Provider.of<UserFavouriteProvider>(context, listen: false)
            .getUserFavProduct(userid, apikey)
            .then((value) {
          print('My Message${value.message}');
          value.data.forEach((element) {
            mFavouriteList.add(Datas(
                specialPriceType: element.specialPriceType,
                specialPrice: element.specialPrice,
                sku: element.sku,
                shortDescription: element.shortDescription,
                qty: element.qty,
                manageStock: element.manageStock,
                isProductNew: element.isProductNew,
                isProductIsInSale: element.isProductIsInSale,
                isProductHasSpecialPrice: element.isProductHasSpecialPrice,
                inStock: element.inStock,
                images: element.images,
                price: element.price,
                productId: element.productId,
                name: element.name));
          });
        });
        setState(() {
          favinit = false;
        });
      }
    });

    return favinit
        ? Center(
            child: CircularProgressIndicator(),
          )
        : email.isEmpty
            ? DefaultUserProfile(
                istab: false,
              )
            : Container(
                margin: EdgeInsets.only(
                    top: spacing_middle, right: spacing_standard_new),
                child: GridView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 0.8),
                  itemCount: mFavouriteList.length,
                  itemBuilder: (context, index) {
                    return StoreDeal(mFavouriteList[index], index);
                  },
                ),
              );
  }
}

class StoreDeal extends StatelessWidget {
  Datas model;

  StoreDeal(Datas model, int pos) {
    this.model = model;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        /*GroceryProductDescription().launch(context);*/
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.38,
        decoration: boxDecoration(
            showShadow: true, radius: 10.0, bgColor: grocery_color_white),
        margin: EdgeInsets.only(left: 16, bottom: 16),
        padding: EdgeInsets.all(spacing_middle),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                      left: spacing_control, right: spacing_control),
                  decoration: boxDecoration(
                      radius: spacing_control, bgColor: grocery_color_white),
                  child: text('', fontSize: textSizeSmall, isCentered: true),
                ),
                Icon(Icons.favorite, color: grocery_color_red)
              ],
            ),
            SizedBox(height: 4),
            Align(
              alignment: Alignment.center,
              child: CachedNetworkImage(
                placeholder: placeholderWidgetFn(),
                imageUrl: model.images[0],
                fit: BoxFit.fill,
                height: width * 0.25,
                width: width * 0.27,
              ),
            ),
            SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 4, right: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  text(model.name,
                      fontFamily: fontMedium,
                      textColor: grocery_textColorPrimary.withOpacity(0.7)),
                  text("₹ ${double.parse(model.price).toStringAsFixed(2)}"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
