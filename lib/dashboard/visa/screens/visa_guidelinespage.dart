import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:outc/dashboard/visa/widgets/colors.dart';

class VisaGuidelinesPage extends StatelessWidget {
  const VisaGuidelinesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: const EdgeInsets.only(right: 10, left: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    child: Icon(
                      Icons.arrow_back_ios_new_outlined,
                      color: Visa_Colours.strongRed,
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 5.0, bottom: 5.0),
                      child: Text(
                        'Visa Guidelines',
                        style: GoogleFonts.poppins(
                            color: Visa_Colours.strongRed,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.more_vert,
                    color: Colors.transparent,
                  ),
                ],
              ),

              const SizedBox(
                height: 10,
              ),

              const ContentCard(
                  title: '1. What Is a Visa?',
                  subContent:
                      'A citizen of a foreign country who seeks to enter the Country generally must first obtain a visa',
                  subTitle: 'Description',
                  content:
                      'A citizen of a foreign country who seeks to enter the United States generally must first obtain a U.S. visa, which is placed in the traveler’s passport, a travel document issued by the traveler’s country of citizenship.Certain international travelers may be eligible to travel to the United States without a visa if they meet the requirements for visa-free travel. The Visa section of this website is all about U.S. visas for foreign citizens to travel to the United States. (Note: U.S. citizens don’t need a U.S. visa for travel, but when planning travel abroad may need a visa issued by the embassy of the country they wish to visit. In this situation, when planning travel abroad, learn about visa requirements by country, see Country Specific Travel Information in the Passport section of this website.)'),

              const SizedBox(
                height: 10,
              ),
              const ContentCard(
                  title: '2. What Does a Visa Look Like?',
                  subContent: 'What Does a Visa Look Like?',
                  subTitle: 'Description',
                  content:
                      'A visa is a sticker on your passport, containing your name, picture, and the number of days you are allowed to stay in a specific country.In some cases, visas are also issued as separate documents and are not attached to your passport – such as electronic visas, which you must print out.'),

              const SizedBox(
                height: 10,
              ),
              const ContentCard(
                  title: '3. A Brief History of Travel Visas',
                  subContent:
                      'The word visa originates from Modern Latin “charta visa',
                  subTitle: 'Description',
                  content:
                      'The word visa originates from Modern Latin “charta visa,” which means verified paper or translated into “paper that has to be seen.” Previously, visas were separate documents that went hand in hand with the passport during international travel, but nowadays, most visas are stamps or stickers attached to your passport.'),

              const SizedBox(
                height: 10,
              ),
              const ContentCard(
                title: '4. Visa Types by Purpose',
                subContent:
                    'Some of the common visa types by purpose of travel include',
                subTitle: 'Description',
                content: [
                  'Tourist visas ',
                  'Transit visas ',
                  'Medical visa ',
                  'Working holiday visas ',
                  'Student visas',
                  'Work visas',
                  'Family reunification visas',
                  'Official visas',
                  'Refuge or asylum visas',
                  'Digital nomad visas',
                  'Retirement visas',
                  'Pilgrimage visas',
                ],
              ),

              const SizedBox(
                height: 10,
              ),

              const ContentCard(
                title: '5. Visa-Free Travel',
                subContent: 'Not everyone requires a visa to travel.',
                subTitle: 'Description',
                content: [
                  'Not everyone requires a visa to travel. Many countries have visa waiver agreements, which means they allow citizens of a select few countries to enter visa-free for short trips. Passport holders of Western countries (such as the U.S., Australia, Canada, and the EU States) can travel to most places without a visa.',
                  'The allowed time for visa-free stays is short; it ranges from a few days to a few months. Regardless of your nationality, you should check your visa requirements before traveling',
                ],
              ),
              const SizedBox(
                height: 10,
              ),

              const ContentCard(
                title: '6. Ways to Get a Travel Visa',
                subContent:
                    'Most commonly, you apply for a visa through one of the following ways:',
                subTitle: 'Description',
                content: [
                  'At an embassy or consulate of the country that you will visit.',
                  'Online (electronic visa).',
                  'At the point of entry (visa on arrival).',
                  'The method of application depends on the specific country and your nationality.',
                  'You should never travel without checking your visa requirements.'
                ],
              ),

              const SizedBox(
                height: 10,
              ),

              const ContentCard(
                title: '7. Common Reasons for Visa Denial',
                subContent:
                    'These are some of the most common reasons why your visa application may be denied',
                subTitle: 'Description',
                content: [
                  'Passport validity. Most countries will require you to have a valid passport with at least a three or six months validity period. However, whether this period begins when you enter or depart the country depends on your travel destination.',
                  'Passport blank pages. The number of required blank pages on your passport differs from country to country, but it is usually two to four pages. Blank pages are required so there is enough space to stamp your passport and visa. ',
                  'Vaccination requirements. Several countries in Africa ask you to have an international vaccination certificate; otherwise, you won’t be granted a visa. ',
                  'Criminal record. It’s almost impossible to obtain a visa with a criminal record; only a few select countries, i.e., the US, and Canada, will grant a waiver for your criminal record when you need a visa. ',
                  'Travel ban. All governments have the power to declare a person “persona non grata.” As a result, diplomats and non-diplomats will not be allowed to enter a specific country.'
                      'Inadequate health insurance coverage. In many countries it is obligatory for all visitors to have travel health insurance coverage.'
                ],
              ),

              const SizedBox(
                height: 10,
              ),

              const ContentCard(
                title: '8. Visa Duration and Validity',
                subContent:
                    'Visas can be issued for the following durations and validities',
                subTitle: 'Description',
                content: [
                  'Short-stay A short-stay visa can be issued for anywhere between a few days to several months. This type of visa is usually issued for tourists, business people, or other short-term purposes, like seeking medical attention or visiting family. ',
                  'Long-stay A long-stay visa can be issued for months or years. Sometimes, residence permits are also referred to as long-stay visas.',
                  'Single-entry As the name suggests, a single-entry visa only allows you to enter that specific country or area once. After you leave, you cannot return, even if you have remaining days.',
                  'Multiple-entry With a multiple-entry visa, you can enter a country or area multiple times, as long as the visa is valid.',
                ],
              ),

              const SizedBox(
                height: 10,
              ),

              const ContentCard(
                title:
                    '9. What is the Difference Between a Passport and a Visa?',
                subContent:
                    'While they are both travel documents, the main difference between a passport and a visa is that a passport is issued from your home country, whereas a visa is issued by the country you want to visit. Other differences include',
                subTitle: 'Description',
                content: [
                  'The passport is an identification travel document, whereas a visa is attached to your passport, showing you have permission to enter a specific country.A passport is issued for about ten years, whereas a visa’s duration is shorter, usually a few months.',
                ],
              ),

              const SizedBox(
                height: 10,
              ),

              const ContentCard(
                title:
                    '10. What Is the Difference Between a Visa and a Residence Permit?',
                subContent:
                    'The terms visa and a residence permit are often used interchangeably. However, a notable difference between the two is:',
                subTitle: 'Description',
                content: [
                  'You need a visa to travel to and enter a foreign country, either for tourism, business, work, studies, etc., usually for a short period.',
                  'You need a residence permit to settle in a foreign country for an extended period.',
                  'Sometimes, you receive a visa first and then convert it into a residence permit once you enter your destination country. Other times, you automatically get a residence permit as soon as you apply for a long-stay visa (work, study, family reunion, etc.)',
                ],
              ),

              const SizedBox(
                height: 10,
              ),

              const ContentCard(
                title: '11. Ways to Get a Travel Visa',
                subContent: 'Travel visa',
                subTitle: 'Description',
                content: [
                  'Akbar Travels has been a part of more than one million travel dreams. We offer a superior, quick and hassle-free Singapore Visa Facilitation service. With a highly professional and dedicated team of Travel visa Experts, we are here to cater to all your Singapore Visa requirements. Throughout your Singapore tourist visa process, you will have a dedicated visa expert handling your application.',
                  'Here are the steps to apply for Singapore Visa online through Akbar Travels:',
                  'Step 1: Provide your travel details to our Visa Expert and get all your queries answered.',
                  'Step 2: Pay your Singapore visa cost online and get your documents picked by us.',
                  'Step 3: Your documents will be thoroughly verified and scrutinized by our Experts and further submitted to the Embassy.',
                  'Step 4: Receive your Singapore Visa online.',
                ],
              ),

              //  )
            ],
          ),
        ),
      ),
    );
  }
}

class ContentCard extends StatelessWidget {
  final String title;
  final String subContent;
  final String subTitle;
  final dynamic content;

  const ContentCard({
    super.key,
    required this.title,
    required this.subTitle,
    required this.content,
    required this.subContent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            color: Visa_Colours.dardModerateBlue,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          subContent,
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          subTitle,
          style: GoogleFonts.poppins(
            color: Visa_Colours.dardModerateBlue,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        content is String
            ? Text(
                content,
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  height: 1.7,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 10,
                overflow: TextOverflow.ellipsis,
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: (content as List<String>).map((line) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        line,
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          height: 1.5,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 5),
                    ],
                  );
                }).toList(),
              ),
        const SizedBox(height: 10),
      ],
    );
  }
}
