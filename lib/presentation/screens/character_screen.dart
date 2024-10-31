import 'package:breaking_bad_proj/business_logic/cubit/characters_cubit.dart';
import 'package:breaking_bad_proj/constants/my_colors.dart';
import 'package:breaking_bad_proj/data/models/characters.dart';
import 'package:breaking_bad_proj/presentation/widgets/character_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';

class CharacterScreen extends StatefulWidget {
  const CharacterScreen({super.key});

  @override
  State<CharacterScreen> createState() => _CharacterScreenState();
}
// 1 >> create blockProvider and the provider create block ,, and gave him to blockBuilder to build items
// blockProvider create one instance from Block and is lazy == يعني مش شغال
// عشان يشتغل بعمل الكود دا >> BlocProvider.of<CharactersCubit>(context).retrieveAllCharacters()

// انا امتي بعمل متغير عشان احفظ فيه القيم زي تحت
class _CharacterScreenState extends State<CharacterScreen> {
  late List<CharactersModel> allCharacters; // دي ال فيها الداتا كلها
  late List<CharactersModel>
      searchedForCharacters; // دي الليست الفاضيه عايز احط في العناصر الي بتبدأ بالحروف الي عايز ابحث عنها

  bool _isSearching = false;
  final _textSearchController = TextEditingController();

  Widget _buildSearchField() {
    return TextField(
      controller: _textSearchController, //
      cursorColor: MyColors.myGrey,
      decoration: const InputDecoration(
          hintText: "Find a character...",
          border: InputBorder.none,
          hintStyle: TextStyle(color: MyColors.myGrey, fontSize: 18)),
      style: const TextStyle(color: MyColors.myGrey, fontSize: 18),
      onChanged: (searchedCharacter) {
        addSearchedForItemsToSearchedList(searchedCharacter);
      },
    );
  }

  void addSearchedForItemsToSearchedList(String searchedCharacter) {
    searchedForCharacters = allCharacters
        .where(
          (character) =>
              character.name!.toLowerCase().startsWith(searchedCharacter),
        )
        .toList();
    setState(() {});
  }

  List<Widget> _buildAppBarAction() {
    if (_isSearching) {
      return [
        IconButton(
            onPressed: () {
              _clearSearch();
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.clear,
              color: MyColors.myGrey,
            ))
      ];
    } else {
      return [
        IconButton(
          onPressed: _startSearch,
          icon: const Icon(
            Icons.search,
            color: MyColors.myGrey,
          ),
        )
      ];
    }
  }

//default backButton هنا افترض الي انا روحت لمسار تاني فهيعمل
  void _startSearch() {
    ModalRoute.of(context)!
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearching() {
    _clearSearch();
    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearch() {
    setState(() {
      _textSearchController.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CharactersCubit>(context)
            .retrieveAllCharacters()
            ?.cast<CharactersModel>() ??
        <CharactersModel>[];
  }

  Widget buildBlockWidget() {
    return BlocBuilder<CharactersCubit, CharactersState>(
      builder: (context, state) {
        if (state is CharactersLoaded) {
          allCharacters = (state).characters.cast<CharactersModel>(); //
          return buildLoadedListWidgets();
        } else {
          return showLoadingIndicator();
        }
      },
    );
  }

  Widget buildLoadedListWidgets() {
    return SingleChildScrollView(
      child: Container(
        color: MyColors.myGrey,
        child: Column(
          children: [
            buildCharacterList(),
          ],
        ),
      ),
    );
  }

  Widget buildCharacterList() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 1,
          mainAxisSpacing: 1,
          childAspectRatio: 2 / 3),
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: _textSearchController.text.isEmpty
          ? allCharacters.length
          : searchedForCharacters.length,
      itemBuilder: (context, index) {
        return CharacterItem(
          // build character Item
          character: _textSearchController.text.isEmpty
              ? allCharacters[index]
              : searchedForCharacters[index],
        );
      },
    );
  }

  Widget showLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        color: MyColors.myYellow,
      ),
    );
  }

  Widget _appBarTitle() {
    return const Text(
      "Caracters",
      style: TextStyle(color: MyColors.myGrey),
    );
  }

  buildNoInternetWidget() {
    return Center(
      child: Container(
        color: MyColors.myWhite,
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              "can't connect .. check internet",
              style: TextStyle(fontSize: 22, color: MyColors.myGrey),
            ),
            Image.asset("assets/images/OIP.jpeg")
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.myYellow,
        title: _isSearching ? _buildSearchField() : _appBarTitle(),
        actions: _buildAppBarAction(),
        leading: _isSearching
            ? const BackButton(
                color: MyColors.myGrey,
              )
            : Container(),
      ),
      body: OfflineBuilder(
          connectivityBuilder: (
            BuildContext context,
            List<ConnectivityResult> connectivity,
            Widget child,
          ) {
            final bool connected =
                !connectivity.contains(ConnectivityResult.none);
            if (connected) {
              return buildBlockWidget();
            } else {
              return buildNoInternetWidget();
            }
          },
          child: showLoadingIndicator()),
    );
  }
}
