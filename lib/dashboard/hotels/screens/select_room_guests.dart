import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:outc/dashboard/hotels/models/hotels_search_payload.dart';
import 'package:outc/dashboard/hotels/screens/search_hotel.dart';
import 'package:outc/dashboard/hotels/widgets/colors.dart';

import 'package:outc/widgets/components/toast.dart';
import 'package:outc/widgets/sharedprefservices.dart';

class SelectRoomGuests extends StatefulWidget {
  List<listModel> editableFinallist;

  SelectRoomGuests({
    super.key,
    required this.editableFinallist,
  });

  @override
  _SelectRoomGuestsState createState() => _SelectRoomGuestsState();
}

class _SelectRoomGuestsState extends State<SelectRoomGuests> {
  int numberOfRooms = SharedPrefServices.getroomCount() ?? 1;
  int guestCount = SharedPrefServices.getguestCount() ?? 1;
  List<int?> adultsPerRoom = [];
  List<int?> childrenPerRoom = [];
  List<List<int?>> childrenAgesPerRoom = [[]];
  List<listModel> finalList = [];

  @override
  void initState() {
    super.initState();
    updateData();
    // _currentRangeValues = RangeValues(
    //     double.parse(widget.filterData!.price!.minPrice.toString()),
    //     double.parse(widget.filterData!.price!.maxPrice.toString()));
  }

  void addRoom() {
    setState(() {
      numberOfRooms++;
      adultsPerRoom.add(1);
      childrenPerRoom.add(0);
      childrenAgesPerRoom.add([]);
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.editableFinallist);
    print(SharedPrefServices.getroomCount());
    inspect(widget.editableFinallist);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "AnjMal",
          style: TextStyle(
            fontSize: 22.0,
            fontFamily: 'poppins',
            color: Hotels_Colours.strongRed,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.grey,
        ),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: IconButton(
              color: Hotels_Colours.strongRed,
              icon: Icon(
                Icons.wallet,
                size: 28,
                color: Hotels_Colours.strongRed,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        content: Container(
                          color: Colors.transparent,
                          height: 80,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                "My Wallet Balance",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "INR ${SharedPrefServices.getwalletblc()}",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Hotels_Colours.strongRed,
                                  fontFamily: 'Poppins',
                                  // fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              },
            ),
          ),
          IconButton(
            color: Hotels_Colours.strongRed,
            icon: const ImageIcon(
              AssetImage(
                "images/notifybell.png",
              ),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.grey[500],
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new_outlined,
                        color: Hotels_Colours.strongRed,
                        size: 24,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Text('Add Number Of Rooms and Guests',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Hotels_Colours.strongRed,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Number of Rooms Selected: $numberOfRooms',
                      style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none),
                    ),
                    const SizedBox(height: 20),
                    for (int i = 0; i < numberOfRooms; i++)
                      RoomSelector(
                        roomNumber: i + 1,
                        adults: adultsPerRoom[i] ?? 1,
                        children: childrenPerRoom[i] ?? 0,
                        childrenAges: childrenAgesPerRoom[i],
                        onAdultsChanged: (int? adults) {
                          setState(() {
                            adultsPerRoom[i] = adults;
                          });
                        },
                        onChildrenChanged: (int? children) {
                          setState(() {
                            childrenPerRoom[i] = children;
                            childrenAgesPerRoom[i] =
                                List<int?>.filled(children ?? 0, null);
                          });
                        },
                        onChildrenAgesChanged: (List<int?> ages) {
                          setState(() {
                            childrenAgesPerRoom[i] = ages;
                          });
                        },
                        onRoomDelete: () {
                          setState(() {
                            if (numberOfRooms > 1) {
                              adultsPerRoom.removeAt(i);
                              childrenPerRoom.removeAt(i);
                              childrenAgesPerRoom.removeAt(i);
                              numberOfRooms--;
                            }
                          });
                        },
                      ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (numberOfRooms >= 6) {
                                showToast("Max limit exceeded.");
                              } else {
                                addRoom();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: Hotels_Colours.strongRed,
                                fixedSize: const Size(330, 48),
                                textStyle: const TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.white,
                                  fontFamily: 'Poppins-regular',
                                  fontWeight: FontWeight.w700,
                                )),
                            child: const Text(
                              'ADD ROOM',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () async {
                              print('Searching...');
                              int sum = 0;
                              for (var e in adultsPerRoom) {
                                sum += e!;
                              }
                              int sum2 = 0;
                              for (var e in childrenPerRoom) {
                                sum2 += e!;
                              }
                              guestCount = sum + sum2;

                              SharedPrefServices.setguestCount(guestCount);
                              SharedPrefServices.setroomCount(numberOfRooms);
                              widget.editableFinallist.clear();
                              for (int i = 0; i < numberOfRooms; i++) {
                                print('Room ${i + 1} Guests: $guestCount');
                                final List<String> formattedAges =
                                    childrenAgesPerRoom[i]
                                        .map((age) => age == null
                                            ? '<1'
                                            : (age < 0 ? '<1' : age.toString()))
                                        .toList();

                                widget.editableFinallist.add(listModel(
                                    noOfAdults: adultsPerRoom[i]!,
                                    noOfChilds: childrenPerRoom[i]!,
                                    childAge: formattedAges));

                                print({
                                  "noOfAdults": adultsPerRoom[i],
                                  "noOfChilds": childrenPerRoom[i],
                                  "childAge": formattedAges,
                                });
                              }

                              print(widget.editableFinallist);
                              inspect(widget.editableFinallist);

                              ListModelHotels listModelHotels = ListModelHotels(
                                  checkInDate: "",
                                  checkOutDate: "",
                                  countryCode: "",
                                  currency: "",
                                  hotelCityCode: "",
                                  hotelCityName: "",
                                  isHotelDescriptionRequried: false,
                                  membership: 0,
                                  nationality: "",
                                  roleType: 0,
                                  roomGuests: widget.editableFinallist,
                                  userId: 0);
                              SharedPrefServices.setroomCount(
                                  widget.editableFinallist.length);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return HotelSearchPage(
                                      payloadData: listModelHotels,
                                    );
                                  },
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: Hotels_Colours.strongRed,
                                fixedSize: const Size(330, 48),
                                textStyle: const TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.white,
                                  fontFamily: 'Poppins-regular',
                                  fontWeight: FontWeight.w700,
                                )),
                            child: const Text(
                              'DONE',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  onRoomDelete(int ind) {
    // need to fix
    if (ind > 1) {
      widget.editableFinallist.removeAt(ind);
    }
  }

  void onAdultsChanged(int? value) {
    // need to fix
  }

  void onChildrenChanged(int? value) {
    // need to fix
  }

  updateData() {
    for (var a in widget.editableFinallist) {
      adultsPerRoom.add(a.noOfAdults);
      childrenPerRoom.add(a.noOfChilds);
      childrenAgesPerRoom.add(a.childAge.cast<int?>());
    }

    // print(adultsPerRoom);
    // print(childrenPerRoom);
    // print(childrenAgesPerRoom);
  }
}

class listModel {
  int noOfAdults;
  int noOfChilds;
  List childAge;
  // Updated data type to List<String>

  listModel({
    required this.noOfAdults,
    required this.noOfChilds,
    required this.childAge,
  });

  Map<dynamic, dynamic> toJson() {
    return {
      'noOfAdults': noOfAdults.toInt(),
      'noOfChilds': noOfChilds.toInt(),
      'childAge': childAge.toList(),
    };
  }
}

class RoomSelector extends StatelessWidget {
  final int roomNumber;
  final int adults;
  final int children;
  final List<int?> childrenAges;
  final ValueChanged<int?> onAdultsChanged;
  final ValueChanged<int?> onChildrenChanged;
  final ValueChanged<List<int?>> onChildrenAgesChanged;
  final VoidCallback onRoomDelete;

  const RoomSelector({
    super.key,
    required this.roomNumber,
    required this.adults,
    required this.children,
    required this.childrenAges,
    required this.onAdultsChanged,
    required this.onChildrenChanged,
    required this.onChildrenAgesChanged,
    required this.onRoomDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          // margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10),
          width: double.infinity,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
              boxShadow: [
                BoxShadow(
                    color: Color.fromARGB(255, 197, 197, 197), blurRadius: 2)
              ]),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Room $roomNumber',
                      style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none),
                    ),
                  ),
                  if (roomNumber > 1)
                    IconButton(
                      onPressed: onRoomDelete,
                      icon: Icon(
                        Icons.delete,
                        color: Hotels_Colours.strongRed,
                      ),
                    ),
                ],
              ),
              Row(
                children: [
                  const Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Adults",
                              style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                  fontFamily: 'poppins',
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.none),
                            ),
                          ],
                        ),
                        Text(
                          "Above 12 years",
                          style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.grey,
                              fontFamily: 'poppins',
                              decoration: TextDecoration.none),
                        ),
                      ],
                    ),
                  ),
                  DropdownButton<int?>(
                    dropdownColor: Colors.white,
                    alignment: AlignmentDirectional.topEnd,
                    // adults test
                    value: adults,
                    onChanged: onAdultsChanged,
                    items: List.generate(4, (index) {
                      return DropdownMenuItem<int?>(
                        value: index + 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text((index + 1).toString()),
                        ),
                      );
                    }),
                  ),
                ],
              ),
              const Divider(
                color: Colors.grey,
                height: 2,
              ),
              Row(
                children: [
                  const Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Children",
                              style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                  fontFamily: 'poppins',
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.none),
                            ),
                          ],
                        ),
                        Text(
                          "Below 12 years",
                          style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.grey,
                              fontFamily: 'poppins',
                              decoration: TextDecoration.none),
                        ),
                      ],
                    ),
                  ),
                  DropdownButton<int?>(
                    dropdownColor: Colors.white,
                    value: children,
                    onChanged: onChildrenChanged,
                    items: List.generate(3, (index) {
                      return DropdownMenuItem<int?>(
                        value: index,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(index.toString()),
                        ),
                      );
                    }),
                  ),
                ],
              ),
              if (childrenAges.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    const Text('Children Ages:'),
                    for (int i = 0; i < childrenAges.length; i++)
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Child ${(i + 1)} ',
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                          DropdownButton<int?>(
                            value: childrenAges[i],
                            // int.parse(childrenAges[i]!.toString()),
                            onChanged: (int? value) {
                              final List<int?> updatedAges =
                                  List.from(childrenAges);
                              updatedAges[i] = value;
                              onChildrenAgesChanged(updatedAges);
                            },
                            items: List.generate(13, (index) {
                              if (index == 0) {
                                return const DropdownMenuItem<int?>(
                                  value: null,
                                  child: Text('<1'),
                                );
                              } else {
                                return DropdownMenuItem<int?>(
                                  value: index,
                                  child: Text(index.toString()),
                                );
                              }
                            }),
                          ),
                        ],
                      )
                  ],
                ),
            ]),
          ),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
