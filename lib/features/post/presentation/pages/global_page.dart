import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:uridachi/l10n/app_localizations.dart';
import 'package:uridachi/features/post/presentation/pages/global_postcard.dart';
import '../../../../main.dart';
import '../../domain/entities/sort_by_options.dart';
import 'upload_post_screen.dart';
import 'global_page_original_screen.dart';
import 'package:provider/provider.dart';
import '../providers/post_provider.dart';

class GlobalPage extends StatefulWidget {
  final ScrollController scrollController;

  const GlobalPage({super.key, required this.scrollController});

  @override
  State<GlobalPage> createState() => _GlobalPageState();
}

class _GlobalPageState extends State<GlobalPage>
    with RouteAware, WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool isLoading = false;
  bool isInitialLoad = true;
  bool _isSearching = false;
  Timer? _debounce;
  bool _filterActive = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refreshPosts(); // initial load
    _searchController.addListener(_onSearchChanged);
    _searchFocusNode.addListener(_onFocusChanged);
  }

  Future<void> _refreshPosts() async {
    setState(() {
      isInitialLoad = false;
      isLoading = true;
    });
    await context.read<PostProvider>().fetchRecentPosts(context);
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _debounce?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    _searchController.removeListener(_onSearchChanged);
    _searchFocusNode.removeListener(_onFocusChanged);
    _searchController.clear();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    _searchFocusNode.unfocus();
    _refreshPosts();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    setState(() => _isSearching = true);
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (!mounted) return;
      final sortBy = _filterActive
          ? PostSortByOptions.mostLiked
          : PostSortByOptions.mostRecent;
      await context
          .read<PostProvider>()
          .fetchFilteredPosts(context, _searchController.text, sortBy);
      if (mounted) setState(() => _isSearching = false);
    });
  }

  void _onFocusChanged() {
    if (!_searchFocusNode.hasFocus) {
      _searchController.clear();
      context.read<PostProvider>().clearFilteredPosts();
    }
  }

  @override
  bool get wantKeepAlive => true;

  PreferredSizeWidget _buildAppBar(
      double h, double w, AppLocalizations loc) {
    return AppBar(
      title: Padding(
        padding: EdgeInsets.only(top: h * 0.001093 * 10),
        child: Text(loc.home,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
      ),
      backgroundColor: Colors.white,
      actions: [
        Padding(
          padding: EdgeInsets.only(right: w * 0.04, top: h * 0.001093 * 13),
          child: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddPostScreen()),
              );
            },
            icon: Image.asset(
              'assets/images/new_post_icon.png',
              width: w * 0.07281,
              height: h * 0.03279,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(
      double w, double h, AppLocalizations loc) {
    return SizedBox(
      width: w * 0.002427 * 324,
      height: h * 0.001093 * 50,
      child: TextFormField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
          hintText: loc.ask_uridachi,
          hintStyle: TextStyle(color: Colors.grey[500], height: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: const Color(0xfff0f1ff),
        ),
      ),
    );
  }

  Widget _buildSortingMenu(double w, double h, AppLocalizations loc) {
    return PopupMenuButton<String>(
      color: Colors.white,
      icon: Image.asset(
        'assets/images/dropdown_icon.png',
        width: w * 0.07281,
        height: h * 0.03279,
      ),      itemBuilder: (_) => [
        PopupMenuItem(
          value: PostSortByOptions.mostRecent.name,
          child: Text(loc.latest_sort, style: TextStyle(color: Colors.black)),
        ),
        PopupMenuItem(
          value: PostSortByOptions.mostLiked.name,
          child: Text(loc.popular_sort, style: TextStyle(color: Colors.black)),
        ),
      ],
      onSelected: (v) {
        final sortBy = v == PostSortByOptions.mostLiked.name
            ? PostSortByOptions.mostLiked
            : PostSortByOptions.mostRecent;

        setState(() {
          _filterActive = (sortBy == PostSortByOptions.mostLiked);
        });

        context.read<PostProvider>().fetchFilteredPosts(
          context,
          _searchController.text,
          sortBy,
        );
      },

    );
  }


  Widget _buildSearchResults(
      double w, double h, AppLocalizations loc) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w * 0.038832),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: h * 0.028418),
            child: Row(
              children: [
                Text(loc.korea_japan_sns,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                        color: Colors.black)),
              ],
            ),
          ),
          Divider(color: Colors.grey),
          if (_isSearching)
            Expanded(child: Center(child: CircularProgressIndicator()))
          else
            Expanded(
              child: Consumer<PostProvider>(
                builder: (_, provider, __) => ListView.builder(
                  itemCount: provider.filteredPosts.length,
                  itemBuilder: (ctx, i) {
                    final post = provider.filteredPosts[i];
                    return Column(
                      children: [
                        GlobalPostcard(postViewDto: post, isPreview: true),
                        Padding(
                          padding: EdgeInsets.only(bottom: w * 0.008),
                          child: Divider(color: Color(0xffE0E0E0)),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final loc = AppLocalizations.of(context)!;
    final provider = context.watch<PostProvider>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
        clipBehavior: Clip.antiAlias,
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: _buildAppBar(h, w, loc),
          body: Stack(
            children: [
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildSearchBar(w, h, loc),
                          _buildSortingMenu(w, h, loc),
                        ],
                      ),
                    ),
                    Expanded(
                      child: _searchFocusNode.hasFocus
                          ? _buildSearchResults(w, h, loc)
                          : RefreshIndicator(
                        onRefresh: _refreshPosts,
                        child: OriginalContent(
                          globalPosts: provider.globalPosts,
                          isLoading: isLoading,
                          isInitialLoad: isInitialLoad,
                          scrollController: widget.scrollController,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_searchFocusNode.hasFocus)
                GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: Container(color: Colors.black.withAlpha(128)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
