import 'package:flutter/material.dart';

class TemplateComponent extends StatelessWidget {
  const TemplateComponent({
    super.key,
  });

  void _showTemplateModal(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double maxWidth = screenSize.width * 0.85;
    final double maxHeight = screenSize.height * 0.7;

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      builder: (BuildContext context) {
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxWidth,
              maxHeight: maxHeight,
            ),
            child: Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.zero,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF99C6E5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Template kalimat kartu',
                        style: TextStyle(
                          fontSize: screenSize.width < 400 ? 20 : 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(
                          screenSize.width < 400 ? 8 : 16,
                          8,
                          screenSize.width < 400 ? 8 : 16,
                          16,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFBF5),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(
                              screenSize.width < 400 ? 8.0 : 16.0),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              // Menentukan jumlah kolom berdasarkan lebar layar
                              int crossAxisCount =
                                  3; // Default untuk layar kecil

                              if (constraints.maxWidth >= 600) {
                                crossAxisCount = 4; // Untuk layar besar
                              }

                              // Menyesuaikan spacing berdasarkan ukuran layar
                              double spacing =
                                  constraints.maxWidth < 400 ? 8 : 12;

                              return GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: spacing,
                                  mainAxisSpacing: spacing,
                                  childAspectRatio: 1,
                                ),
                                physics: const ClampingScrollPhysics(),
                                itemCount: 12,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  // Menyesuaikan ukuran gambar berdasarkan lebar layar
                                  double imageSize;
                                  if (constraints.maxWidth < 400) {
                                    imageSize = constraints.maxWidth * 0.12;
                                  } else if (constraints.maxWidth >= 600) {
                                    imageSize = constraints.maxWidth * 0.12;
                                  } else {
                                    imageSize = constraints.maxWidth * 0.15;
                                  }

                                  // Menyesuaikan ukuran font berdasarkan lebar layar
                                  double fontSize =
                                      constraints.maxWidth < 400 ? 10 : 12;

                                  return Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8ECF7),
                                      borderRadius: BorderRadius.circular(
                                          constraints.maxWidth < 400 ? 8 : 12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color.fromRGBO(0, 0, 0, 0.2),
                                          offset: const Offset(2, 2),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/buah_buahan.png',
                                          height: imageSize,
                                        ),
                                        SizedBox(
                                            height: constraints.maxWidth < 400
                                                ? 2
                                                : 4),
                                        Text(
                                          'Buah-buahan',
                                          style: TextStyle(
                                            fontSize: fontSize,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: screenSize.width < 400 ? 8 : 16),
                      child: Container(
                        width: screenSize.width < 400 ? 100 : 120,
                        height: screenSize.width < 400 ? 32 : 40,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.2),
                              offset: const Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Hapus',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenSize.width < 400 ? 14 : 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showTemplateModal(context),
      child: Image.asset(
        'assets/images/tamplate.png',
        height: 43,
        width: 43,
        fit: BoxFit.contain,
      ),
    );
  }
}
