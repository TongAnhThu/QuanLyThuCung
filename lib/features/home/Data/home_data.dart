import 'package:flutter/material.dart';
import '../models/tab_item.dart';

class HomeData {
  static const List<String> banners = [
    'assets/images/banner1.png',
    'assets/images/banner2.png',
    'assets/images/banner3.png',
    'assets/images/banner4.png',
  ];

  static const List<Map<String, String>> homePets = [
    {
      'name': 'Border Collie',
      'subtitle': '2 tháng • 7.000.000 đ',
      'image': 'assets/images/11.jpg',
    },
    {
      'name': 'Phóc Sóc',
      'subtitle': '3 tháng • 8.000.000 đ',
      'image': 'assets/images/12.jpg',
    },
    {
      'name': 'Mèo Anh',
      'subtitle': '2 tháng • 3.500.000 đ',
      'image': 'assets/images/13.jpg',
    },
  ];

  static const List<Map<String, String>> homeItems = [
    {
      'name': 'Hạt Royal Canin',
      'subtitle': 'Bao 2kg • 420.000 đ',
      'image': 'assets/images/thucan.jpg',
    },
    {
      'name': 'Dây dắt da mềm',
      'subtitle': 'Mới • 180.000 đ',
      'image': 'assets/images/daydat.jpg',
    },
    {
      'name': 'Đồ chơi gặm',
      'subtitle': 'Set 3 món • 95.000 đ',
      'image': 'assets/images/dochoi3.jpg',
    },
  ];

  static const List<Map<String, String>> homeServices = [
    {
      'name': 'Spa & tắm',
      'subtitle': 'Từ 180.000 đ',
      'image': 'assets/images/tialong.jpg',
    },
    {
      'name': 'Khách sạn thú cưng',
      'subtitle': '250.000 đ/đêm',
      'image': 'assets/images/nhathucung.jpg',
    },
    {
      'name': 'Tỉa lông',
      'subtitle': 'Từ 150.000 đ',
      'image': 'assets/images/tialong.jpg',
    },
  ];

  static const List<Map<String, String>> posts = [
    {
      'title': 'Top 5 sự thật về chó',
      'content':
          'Chó có khứu giác mạnh gấp 10.000 lần con người và có thể nhớ tới 250 mùi khác nhau. Ngoài ra, chó có khả năng nghe âm thanh ở tần số cao hơn con người rất nhiều, giúp chúng phát hiện nguy hiểm từ xa. Các nghiên cứu cho thấy chó có thể hiểu được hơn 150 từ ngữ và cử chỉ của con người. Chúng cũng có khả năng cảm nhận cảm xúc của chủ nhân qua giọng nói và ngôn ngữ cơ thể. Đặc biệt, chó có thể giúp giảm stress và cải thiện sức khỏe tinh thần của con người qua sự đồng hành hàng ngày.',
      'source': 'cre: Nguyễn Duy Phúc',
    },
    {
      'title': 'Các thức ăn cực độc cho mèo',
      'content':
          'Sô cô la, hành tỏi, nho và sữa bò có thể gây ngộ độc hoặc rối loạn tiêu hóa nghiêm trọng cho mèo. Sô cô la chứa theobromine - chất độc với mèo, có thể gây co giật và suy tim. Hành tỏi phá hủy hồng cầu, dẫn đến thiếu máu. Nho và nho khô có thể gây suy thận cấp tính. Sữa bò khiến nhiều mèo trưởng thành bị tiêu chảy do thiếu enzyme lactase. Ngoài ra, cần tránh cho mèo ăn xương gà (dễ vỡ và đâm thủng ruột), cà phê, rượu, bột nở, và các loại hạt macadamia. Luôn kiểm tra thành phần thức ăn trước khi cho mèo ăn.',
      'source': 'cre: Minh Anh',
    },
    {
      'title': 'Lưu ý khi tắm cho chó',
      'content':
          'Chỉ tắm bằng nước ấm, tránh nước vào tai; dùng sữa tắm dành riêng cho thú cưng để không kích ứng da. Trước khi tắm, hãy chải lông kỹ để loại bỏ lông rụng và rối. Kiểm tra nhiệt độ nước bằng cổ tay để đảm bảo không quá nóng hay lạnh. Thoa sữa tắm nhẹ nhàng theo chiều mọc lông, tránh vùng mắt và tai. Xả sạch hoàn toàn để không còn bọt xà phòng gây ngứa da. Sau tắm, dùng khăn lau khô và sấy ở nhiệt độ vừa phải, giữ khoảng cách an toàn. Tần suất tắm nên 2-4 tuần/lần tùy giống chó và mức độ bẩn.',
      'source': 'cre: Thảo My',
    },
    {
      'title': 'Cách chọn thức ăn hạt',
      'content':
          'Ưu tiên hạt có đạm động vật cao, không chất tạo màu, và phù hợp độ tuổi/giống của thú cưng. Đọc kỹ thành phần trên bao bì: nguồn đạm tốt như thịt gà, thịt bò, cá nên nằm trong top 3 thành phần đầu tiên. Tránh hạt có quá nhiều ngũ cốc rẻ tiền như ngô, lúa mì làm chất độn. Kiểm tra hạn sử dụng và bảo quản đúng cách trong hộp kín, nơi khô ráo. Với chó con, chọn hạt puppy giàu năng lượng; chó trưởng thành cần công thức cân bằng; chó già nên dùng hạt ít calo, bổ sung khớp. Quan sát phản ứng của thú cưng: nếu bị tiêu chảy, rụng lông hay ngứa da, có thể do dị ứng - cần đổi loại hạt khác.',
      'source': 'cre: Gia Bảo',
    },
    {
      'title': 'Dấu hiệu mèo bị stress',
      'content':
          'Mèo trốn kỹ, bỏ ăn, liếm lông quá mức; hãy tạo góc trú an toàn và chơi nhẹ nhàng mỗi ngày. Stress ở mèo có thể biểu hiện qua hành vi hung hăng đột ngột, tiểu bậy ngoài khay vệ sinh, hoặc kêu rên liên tục. Nguyên nhân thường do thay đổi môi trường (chuyển nhà, khách lạ), ồn ào kéo dài, hoặc xung đột với thú cưng khác. Để giảm stress, cung cấp nhiều nơi trú ẩn yên tĩnh ở độ cao khác nhau, sử dụng pheromone xoa dịu, duy trì lịch trình cho ăn đều đặn. Chơi đùa đều đặn với đồ chơi kích thích bản năng săn mồi cũng giúp giải tỏa căng thẳng hiệu quả.',
      'source': 'cre: Khánh Vy',
    },
  ];

  static const List<TabItem> tabs = [
    TabItem(
      label: 'Bài viết',
      icon: Icons.article_outlined,
      description: 'Các bài viết về chăm sóc thú cưng',
    ),
    TabItem(
      label: 'Thú cưng',
      icon: Icons.pets,
      description: 'Danh sách thú cưng đang bán',
    ),
    TabItem(label: 'Trang chủ', icon: Icons.home, description: 'Trang chủ'),
    TabItem(
      label: 'Vật phẩm',
      icon: Icons.inventory_2_outlined,
      description: 'Thức ăn, đồ chơi, quần áo và phụ kiện',
    ),
    TabItem(
      label: 'Dịch vụ',
      icon: Icons.spa_outlined,
      description: 'Tắm, spa, khách sạn thú cưng, chăm sóc khác',
    ),
  ];
}
