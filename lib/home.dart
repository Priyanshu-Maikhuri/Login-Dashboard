import 'package:flutter/material.dart';

class Option {
  String image;
  String title;
  int items;

  Option({required this.image, required this.title, required this.items});
}

class DashBoard extends StatelessWidget {
  DashBoard({super.key});

  final List<Option> _options = [
    Option(image: 'assets/service.webp', title: 'Service', items: 7),
    Option(image: 'assets/driver.png', title: 'Driver', items: 3),
    Option(image: 'assets/hospital.png', title: 'Hospital', items: 10),
    Option(image: 'assets/food.png', title: 'Food', items: 6)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          actions: [
            Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.grey[600]!, // Border color
                    width: 1, // Border width
                  ),
                ),
                child: ClipOval(
                  child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Image.asset('assets/profile.jpeg',
                          fit: BoxFit.cover)),
                ))
          ],
          leading: Icon(
            Icons.menu,
            size: 35,
            color: Colors.grey[200],
          ),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Dashboard options',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                  )),
              const SizedBox(
                height: 15,
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(7),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                      childAspectRatio: 3 / 4),
                  itemBuilder: (ctx, index) {
                    return Card(
                      color: Colors.grey[900],
                      elevation: 10,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset(_options[index].image, scale: 3),
                              Text(
                                _options[index].title,
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${_options[index].items} Items',
                                style: const TextStyle(
                                    fontSize: 8,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w200),
                              ),
                            ]),
                      ),
                    );
                  },
                  itemCount: _options.length,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text('Priyanshu Maikhuri',
                  style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.yellow[400])),
              Text('Android Developer',
                  style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.pinkAccent[400])),
              Text('maikhuripriyanshu@gmail.com',
                  style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.pinkAccent[400])),
              Text('(+91) 9548531031',
                  style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.pinkAccent[400])),
            ],
          ),
        ));
  }
}
