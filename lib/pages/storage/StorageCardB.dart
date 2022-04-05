import 'package:connectivity/connectivity.dart';
import 'package:farmhand/models/storage_locations/inventory_item_element.dart';
import 'package:farmhand/pages/storage/extensions/StorageCardBExt.dart';
import 'package:farmhand/widgets/reusables/Commons.dart';
import 'package:flutter/material.dart';

class StorageCardB extends StatefulWidget {
  final int storageLocationPosition;
  final getindex;
  final InventoryItemElement inventoryItems;
  StorageCardB({
    this.storageLocationPosition,
    this.getindex,
    this.inventoryItems,
  });

  @override
  StorageCardBState createState() => StorageCardBState();
}

class StorageCardBState extends State<StorageCardB> {
  TextEditingController _controller = TextEditingController();
  ConnectivityResult connectivityResult;
  bool isValueChanged = false;

  getConnectivityStatus() async {
    connectivityResult = await (Connectivity().checkConnectivity());
  }

  void initState() {
    super.initState();
    _controller.text = widget.inventoryItems.level.toString();
    getConnectivityStatus();
  }

  @override
  Widget build(BuildContext context) {
    int inventoryTypeId = widget.inventoryItems.inventoryItem.inventoryTypeId;
    String inventoryTypeName;
    inventoryTypeName = Commons.inventoryType(inventoryTypeId);
    var commonSpace = 10.0;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Card(
          margin: EdgeInsets.fromLTRB(4, 4, 4, 10),
          color: Color(0xffF2F2F2),
          shadowColor: Colors.blue.shade300,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 8,
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(28, 10, 28, 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "${widget.getindex + 1}. ${widget.inventoryItems.inventoryItem.name}"
                          .toUpperCase(),
                      style: TextStyle(
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                        decorationColor: Color(0xff136D15),
                        decorationThickness: 2,
                      ),
                    ),
                    SizedBox(
                      width: commonSpace + 10,
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                      color: Colors.grey.shade400,
                      child: Text(
                        inventoryTypeName,
                        style: TextStyle(color: Colors.black, fontSize: 10),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: commonSpace + 5,
                ),
                Text(
                  widget.inventoryItems.inventoryItem.description == null
                      ? ""
                      : widget.inventoryItems.inventoryItem.description,
                  style: TextStyle(
                    color: Color(0xff4D4D4D),
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 4,
                ),
                SizedBox(
                  height: commonSpace + 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Wrap(
                      spacing: 5,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          "Current Level".toUpperCase(),
                          style: TextStyle(
                              color: Color(0xff203825),
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                        Container(
                          width: 60,
                          height: 30,
                          child: TextField(
                            controller: _controller,
                            onChanged: (value) {
                              setState(() {
                                isValueChanged = true;
                              });
                            },
                            enabled: true,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            decoration: new InputDecoration(
                              contentPadding: EdgeInsets.all(0.0),
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.green, width: 1.0),
                              ),
                            ),
                            style: TextStyle(
                              color: Color(0xff136D15),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: isValueChanged
                          ? () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              String levelString = _controller.text;

                              int currentLevel;
                              if (levelString.length > 0) {
                                currentLevel = int.parse(levelString);

                                storeValueInPreferences(
                                  widget.storageLocationPosition,
                                  widget.getindex,
                                  currentLevel,
                                );
                              }
                            }
                          : null,
                      child: Icon(
                        Icons.save,
                        color: isValueChanged ? Colors.green : Colors.grey,
                        size: 30,
                      ),
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }
}
