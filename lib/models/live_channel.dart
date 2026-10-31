class LiveChannel {
  final String id;
  final String name;
  final String category;
  final String logoUrl;
  final String streamUrl;
  final String currentShow;
  final String currentShowTime;
  final String nextShow;
  final String nextShowTime;
  final String viewers;
  final bool isHD;

  const LiveChannel({
    required this.id,
    required this.name,
    required this.category,
    required this.logoUrl,
    required this.streamUrl,
    required this.currentShow,
    required this.currentShowTime,
    required this.nextShow,
    required this.nextShowTime,
    this.viewers = '1.4M',
    this.isHD = true,
  });
}
