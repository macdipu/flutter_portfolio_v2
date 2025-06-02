import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_theme.dart';
import '../bloc/portfolio_bloc.dart';
import 'section_header.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isDesktop = screenSize.width >= 1024;
    final theme = Theme.of(context);
    
    return BlocBuilder<PortfolioBloc, PortfolioState>(
      builder: (context, state) {
        if (state.isLoading && state.profile == null) {
          return const Center(child: CircularProgressIndicator());
        }
        
        final profile = state.profile;
        if (profile == null) {
          return const Center(child: Text('No profile data available'));
        }
        
        final contactInfo = profile.contactInfo;
        
        return Container(
          padding: EdgeInsets.only(
            left: AppTheme.spacing24,
            right: AppTheme.spacing24,
            top: AppTheme.spacing64,
            bottom: AppTheme.spacing64,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                title: 'Contact',
                subtitle: 'Get In Touch',
              ),
              const SizedBox(height: AppTheme.spacing48),
              
              // Contact form and info
              isDesktop
                  ? _buildDesktopLayout(context, state, contactInfo)
                  : _buildMobileLayout(context, state, contactInfo),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildDesktopLayout(BuildContext context, PortfolioState state, dynamic contactInfo) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Contact form
        Expanded(
          child: _buildContactForm(context, state),
        ),
        const SizedBox(width: AppTheme.spacing48),
        
        // Contact info
        Expanded(
          child: _buildContactInfo(context, contactInfo),
        ),
      ],
    );
  }
  
  Widget _buildMobileLayout(BuildContext context, PortfolioState state, dynamic contactInfo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Contact info
        _buildContactInfo(context, contactInfo),
        const SizedBox(height: AppTheme.spacing32),
        
        // Contact form
        _buildContactForm(context, state),
      ],
    );
  }
  
  Widget _buildContactForm(BuildContext context, PortfolioState state) {
    final theme = Theme.of(context);
    
    // Show success message if form submitted
    if (state.isContactFormSubmitted) {
      return _buildSuccessMessage(theme);
    }
    
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Send a Message',
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: AppTheme.spacing24),
              
              // Name field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppTheme.spacing16),
              
              // Email field
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppTheme.spacing16),
              
              // Message field
              TextFormField(
                controller: _messageController,
                decoration: const InputDecoration(
                  labelText: 'Message',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.message),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a message';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppTheme.spacing24),
              
              // Submit button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: state.isContactFormSubmitting
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            context.read<PortfolioBloc>().add(
                                  SubmitContactForm(
                                    name: _nameController.text,
                                    email: _emailController.text,
                                    message: _messageController.text,
                                  ),
                                );
                          }
                        },
                  icon: state.isContactFormSubmitting
                      ? Container(
                          width: 24,
                          height: 24,
                          padding: const EdgeInsets.all(2.0),
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : const Icon(Icons.send),
                  label: Text(
                    state.isContactFormSubmitting ? 'Sending...' : 'Send Message',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fade(duration: 600.ms).slideX(begin: -0.2, end: 0);
  }
  
  Widget _buildSuccessMessage(ThemeData theme) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 64,
            ),
            const SizedBox(height: AppTheme.spacing16),
            Text(
              'Message Sent!',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: AppTheme.spacing8),
            Text(
              'Thank you for reaching out. I\'ll get back to you as soon as possible.',
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacing24),
            ElevatedButton(
              onPressed: () {
                _nameController.clear();
                _emailController.clear();
                _messageController.clear();
                context.read<PortfolioBloc>().add(LoadPortfolioData());
              },
              child: const Text('Send Another Message'),
            ),
          ],
        ),
      ),
    ).animate().fade(duration: 600.ms).scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1));
  }
  
  Widget _buildContactInfo(BuildContext context, dynamic contactInfo) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact Information',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: AppTheme.spacing24),
            
            // Email
            _buildContactItem(
              theme,
              icon: Icons.email,
              title: 'Email',
              value: contactInfo.email,
              onTap: () async {
                final url = Uri.parse('mailto:${contactInfo.email}');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                }
              },
            ),
            const SizedBox(height: AppTheme.spacing16),
            
            // Social links
            Text(
              'Social Media',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: AppTheme.spacing16),
            
            // Social icons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSocialIcon(
                  FontAwesomeIcons.linkedin,
                  contactInfo.linkedIn,
                  theme.colorScheme.primary,
                ),
                _buildSocialIcon(
                  FontAwesomeIcons.github,
                  contactInfo.github,
                  theme.colorScheme.primary,
                ),
                _buildSocialIcon(
                  FontAwesomeIcons.twitter,
                  contactInfo.twitter,
                  theme.colorScheme.primary,
                ),
                _buildSocialIcon(
                  FontAwesomeIcons.dribbble,
                  contactInfo.dribbble,
                  theme.colorScheme.primary,
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacing24),
            
            // Calendly link
            if (contactInfo.calendlyLink.isNotEmpty) ...[
              const Divider(),
              const SizedBox(height: AppTheme.spacing16),
              OutlinedButton.icon(
                onPressed: () async {
                  final url = Uri.parse(contactInfo.calendlyLink);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
                icon: const Icon(Icons.calendar_today),
                label: const Text('Schedule a Meeting'),
              ),
            ],
          ],
        ),
      ),
    ).animate().fade(duration: 600.ms).slideX(begin: 0.2, end: 0);
  }
  
  Widget _buildContactItem(
    ThemeData theme, {
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: AppTheme.spacing16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall,
                  ),
                  Text(
                    value,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSocialIcon(IconData icon, String url, Color color) {
    return IconButton(
      icon: FaIcon(
        icon,
        color: color,
      ),
      onPressed: () async {
        if (url.isNotEmpty) {
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          }
        }
      },
      iconSize: 30,
    );
  }
}