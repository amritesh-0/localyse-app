import 'package:flutter/material.dart';
import '../models/influencer_models.dart';

class CampaignService extends ChangeNotifier {
  static final CampaignService _instance = CampaignService._internal();
  factory CampaignService() => _instance;
  CampaignService._internal() {
    _initializeMockData();
  }

  final List<AdCampaign> _campaigns = [];

  List<AdCampaign> get campaigns {
    if (_campaigns.isEmpty) {
      _initializeMockData();
    }
    return List.unmodifiable(_campaigns);
  }

  void _initializeMockData() {
    if (_campaigns.isNotEmpty) return;
    
    final now = DateTime.now();
    _campaigns.addAll([
      AdCampaign(
        id: '1',
        title: 'Summer Collection Reveal',
        brandName: 'Urban Style Co.',
        brandLogo: 'U',
        description: 'Looking for lifestyle influencers to showcase our new summer line. Must have a vibrant audience.',
        location: 'New York, NY',
        payout: 250.0,
        requirements: ['Min 5k followers', '2 IG Stories', '1 Reel'],
        status: AdStatus.available,
        deadline: now.add(const Duration(days: 3)),
      ),
      AdCampaign(
        id: '2',
        title: 'Organic Juice Bar Opening',
        brandName: 'FreshPress',
        brandLogo: 'F',
        description: 'Local influencers wanted for our grand opening event! Come try our juices and share your experience.',
        location: 'New York, NY',
        payout: 150.0,
        requirements: ['Must be NYC based', 'High engagement'],
        status: AdStatus.available,
        deadline: now.add(const Duration(days: 1)),
      ),
      AdCampaign(
        id: '3',
        title: 'Cafe Branding',
        brandName: 'The Bean Place',
        brandLogo: 'B',
        description: 'Create aesthetic reels highlighting our new seasonal menu.',
        requirements: ['2 Reels', 'IG Story'],
        location: 'New York, NY',
        payout: 100,
        status: AdStatus.applied,
        deadline: now.add(const Duration(days: 2)),
      ),
      AdCampaign(
        id: '4',
        title: 'Fitness Gear Launch',
        brandName: 'IronCore',
        brandLogo: 'I',
        description: 'Showcase our new metabolic equipment in your workout routines.',
        requirements: ['3 Reels', 'Weekly Post'],
        location: 'Global',
        payout: 500,
        status: AdStatus.ongoing,
        deadline: now, // Today
      ),
      AdCampaign(
        id: '5',
        title: 'Tech Gadget Review',
        brandName: 'NextGen',
        brandLogo: 'N',
        description: 'Join our beta program and review our latest smartwatch. We need detailed feedback and social coverage.',
        location: 'New York, NY',
        payout: 300.0,
        requirements: ['Tech-focused niche', 'Detailed review video'],
        status: AdStatus.available,
        deadline: now.add(const Duration(days: 5)),
      ),
      AdCampaign(
        id: '6',
        title: 'Sustainable Fashion Shoot',
        brandName: 'EcoWear',
        brandLogo: 'E',
        description: 'Promote our new line of recycled denim and organic cotton tees.',
        requirements: ['3 IG Posts', 'Sustainability focus'],
        location: 'Los Angeles, CA',
        payout: 450,
        status: AdStatus.applied,
        deadline: now.add(const Duration(days: 4)),
      ),
      AdCampaign(
        id: '7',
        title: 'Vegan Food Festival',
        brandName: 'PureBite',
        brandLogo: 'P',
        description: 'Document your culinary experience at the upcoming vegan festival.',
        requirements: ['Vlog', 'Stories'],
        location: 'Austin, TX',
        payout: 350,
        status: AdStatus.approved,
        deadline: now, // Today
      ),
      AdCampaign(
        id: '8',
        title: 'Home Office Setups',
        brandName: 'WorkWell',
        brandLogo: 'W',
        description: 'Showcase your ergonomic office setup with our new standing desk.',
        requirements: ['2 Reels', 'Desk review'],
        location: 'Remote',
        payout: 600,
        status: AdStatus.ongoing,
        deadline: now.add(const Duration(days: 1)), // Tomorrow
      ),
      AdCampaign(
        id: '9',
        title: 'Winter Travel Series',
        brandName: 'GlobeTrot',
        brandLogo: 'G',
        description: 'Capture the magic of winter in the Alps with our luxury travel gear.',
        requirements: ['Travel Vlog', 'Photo Gallery'],
        location: 'Global',
        payout: 1500,
        status: AdStatus.pendingPayment,
        deadline: now.subtract(const Duration(days: 2)),
      ),
      AdCampaign(
        id: '10',
        title: 'Tech Unboxing',
        brandName: 'GigaTech',
        brandLogo: 'G',
        description: 'Unbox and review the latest RTX GPUs.',
        requirements: ['YouTube Video', 'Shorts'],
        location: 'Remote',
        payout: 800,
        status: AdStatus.approved,
        deadline: now.add(const Duration(days: 2)),
      ),
      AdCampaign(
        id: '11',
        title: 'Fragrance Review',
        brandName: 'Oud Luxe',
        brandLogo: 'O',
        description: 'Share your honest opinion on our new signature scent.',
        requirements: ['Lifestyle Post'],
        location: 'Paris',
        payout: 150,
        status: AdStatus.pendingPayment,
        deadline: now.subtract(const Duration(days: 1)),
      ),
      AdCampaign(
        id: '12',
        title: 'Organic Food Tour',
        brandName: 'GreenPlate',
        brandLogo: 'G',
        description: 'Visit our farm-to-table restaurants and document the journey.',
        requirements: ['Vlog', 'Stories'],
        location: 'California',
        payout: 1200,
        status: AdStatus.paid,
        deadline: now.subtract(const Duration(days: 10)),
      ),
    ]);
  }

  void updateCampaignStatus(String id, AdStatus newStatus) {
    final index = _campaigns.indexWhere((c) => c.id == id);
    if (index != -1) {
      _campaigns[index] = _campaigns[index].copyWith(status: newStatus);
      notifyListeners();
    }
  }

  List<AdCampaign> getCampaignsByStatus(AdStatus status) {
    return _campaigns.where((c) => c.status == status).toList();
  }

  List<AdCampaign> getNearbyCampaigns(String location) {
    return _campaigns.where((c) => c.location == location && c.status == AdStatus.available).toList();
  }
}
