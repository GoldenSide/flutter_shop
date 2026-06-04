import 'package:flutter/material.dart';
import 'package:flutter_dianshang/api/home.dart';
import 'package:flutter_dianshang/viewmodels/home.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({Key? key}) : super(key: key);

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  List<Category> _categoryList = [];
  int _selectedIndex = 0;
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final list = await fetchCategoryItems();
    setState(() {
      _categoryList = list;
      _isLoading = false;
    });
  }

  Category get _currentCategory {
    if (_categoryList.isEmpty) {
      return Category(id: '', name: '', picture: '');
    }
    return _categoryList[_selectedIndex];
  }

  List<Category> get _currentChildren {
    return _currentCategory.children ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildSearchBar(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _categoryList.isEmpty
              ? const Center(child: Text('暂无分类数据'))
              : Row(
                  children: [
                    _buildLeftCategoryList(),
                    Expanded(child: _buildRightContent()),
                  ],
                ),
    );
  }

  PreferredSizeWidget _buildSearchBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(56),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        color: Colors.white,
        child: Row(
          children: [
            const Expanded(
              child: Text(
                '分类',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              width: 200,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(18),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                style: const TextStyle(fontSize: 13, color: Colors.black),
                textInputAction: TextInputAction.search,
                onSubmitted: (value) {
                  // 点击键盘"搜索"按钮时触发
                  if (value.trim().isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('搜索：$value'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  }
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '搜索商品',
                  hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
                  isCollapsed: true,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  icon: const Icon(
                    Icons.search,
                    size: 18,
                    color: Colors.grey,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _searchController.clear();
                      });
                    },
                    child: AnimatedBuilder(
                      animation: _searchController,
                      builder: (context, child) {
                        return _searchController.text.isNotEmpty
                            ? const Icon(
                                Icons.clear,
                                size: 16,
                                color: Colors.grey,
                              )
                            : const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                onChanged: (value) {
                  // 让 suffixIcon 的显示/隐藏随输入实时更新
                  // (AnimatedBuilder 已经监听了 _searchController)
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftCategoryList() {
    return Container(
      width: 100,
      color: const Color(0xFFF5F5F5),
      child: ListView.builder(
        itemCount: _categoryList.length,
        itemBuilder: (context, index) {
          final isSelected = index == _selectedIndex;
          final category = _categoryList[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.transparent,
                border: Border(
                  left: BorderSide(
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.transparent,
                    width: 3,
                  ),
                ),
              ),
              child: Text(
                category.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.black : Colors.grey[700],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRightContent() {
    return Container(
      color: Colors.white,
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _buildCategoryHeader(),
          if (_currentChildren.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildSubCategoryGrid(),
          ],
          const SizedBox(height: 16),
          _buildSectionTitle('热门推荐'),
          const SizedBox(height: 10),
          _buildRecommendProducts(),
        ],
      ),
    );
  }

  Widget _buildCategoryHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      child: Row(
        children: [
          if (_currentCategory.picture.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                _currentCategory.picture,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.category, color: Colors.grey),
                  );
                },
              ),
            )
          else
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.category, color: Colors.grey),
            ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _currentCategory.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '共 ${_currentChildren.length} 个子分类',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubCategoryGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.85,
      ),
      itemCount: _currentChildren.length,
      itemBuilder: (context, index) {
        final child = _currentChildren[index];
        return GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('进入「${child.name}」'),
                  duration: const Duration(seconds: 1)),
            );
          },
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: child.picture.isNotEmpty
                      ? Image.network(
                          child.picture,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[100],
                              child:
                                  const Icon(Icons.image, color: Colors.grey),
                            );
                          },
                        )
                      : Container(
                          width: double.infinity,
                          color: Colors.grey[100],
                          child: const Icon(Icons.image, color: Colors.grey),
                        ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                child.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, color: Colors.black87),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 14,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 6),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendProducts() {
    final List<dynamic> rawGoods = _currentCategory.goods ?? [];
    if (rawGoods.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text('暂无推荐商品', style: TextStyle(color: Colors.grey)),
        ),
      );
    }
    final List<GoodsItem> items = rawGoods
        .map((e) {
          if (e is Map<String, dynamic>) {
            try {
              return GoodsItem.fromJson(e);
            } catch (_) {
              return null;
            }
          }
          return null;
        })
        .whereType<GoodsItem>()
        .toList();

    if (items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text('暂无推荐商品', style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.7,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(8)),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    item.picture,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.image, color: Colors.grey),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(6),
                child: Text(
                  item.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Text(
                  '¥${item.price}',
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
