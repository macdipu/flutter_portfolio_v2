import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_portfolio/features/portfolio/data/models/profile_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/responsive/responsive_framework.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/common/section_wrapper.dart';
import '../bloc/portfolio_bloc.dart';

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
    return BlocBuilder<PortfolioBloc, PortfolioState>(
      buildWhen: (prev, curr) =>
          prev.isLoading != curr.isLoading ||
          prev.profile != curr.profile ||
          prev.isContactFormSubmitting != curr.isContactFormSubmitting ||
          prev.isContactFormSubmitted != curr.isContactFormSubmitted,
      builder: (context, state) {
        final r = context.responsive;
        final profile = state.profile;

        if (state.isLoading && profile == null) {
          return const SectionWrapper(
            title: 'Contact',
            subtitle: 'Get In Touch',
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (profile == null) {
          return const SectionWrapper(
            title: 'Contact',
            subtitle: 'Get In Touch',
            child: Center(child: Text('No profile data available')),
          );
        }

        final contactInfo = profile.contactInfo;
        final isWide = !r.isMobileOrTablet;

        return SectionWrapper(
          sectionId: 'contact',
          title: 'Contact',
          subtitle: 'Get In Touch',
          addTopPadding: true,
          addBottomPadding: true,
          child: Container(
            width: context.contentWidth,
            padding: context.defaultPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48),
                isWide
                    ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Expanded(child: _buildContactForm(context, state, r)),
                        const SizedBox(width: 48),
                        Expanded(child: _buildContactInfo(context, contactInfo, r)),
                      ])
                    : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        _buildContactInfo(context, contactInfo, r),
                        const SizedBox(height: 32),
                        _buildContactForm(context, state, r),
                      ]),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContactForm(BuildContext context, PortfolioState state, ResponsiveInfo r) {
    final theme = Theme.of(context);
    final titleStyle = (theme.textTheme.headlineSmall ?? const TextStyle()).copyWith(
      fontSize: AppTypography.heading(r),
    );
    final buttonLabelStyle = (theme.textTheme.labelLarge ?? const TextStyle()).copyWith(
      fontSize: AppTypography.bodyMedium(r),
    );

    if (state.isContactFormSubmitted) return _buildSuccessMessage(r);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SelectableText('Send a Message', style: titleStyle),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name', prefixIcon: Icon(Icons.person)),
                validator: (v) => (v == null || v.isEmpty) ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email)),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Please enter your email';
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) return 'Please enter a valid email';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _messageController,
                maxLines: 5,
                decoration: const InputDecoration(labelText: 'Message', alignLabelWithHint: true, prefixIcon: Icon(Icons.message)),
                validator: (v) => (v == null || v.isEmpty) ? 'Please enter a message' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: state.isContactFormSubmitting
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            context.read<PortfolioBloc>().add(SubmitContactForm(
                              name: _nameController.text,
                              email: _emailController.text,
                              message: _messageController.text,
                            ));
                          }
                        },
                  icon: state.isContactFormSubmitting
                      ? SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Theme.of(context).colorScheme.onPrimary, strokeWidth: 3))
                      : const Icon(Icons.send),
                  label: Text(state.isContactFormSubmitting ? 'Sending...' : 'Send Message', style: buttonLabelStyle),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fade(duration: 400.ms).slideX(begin: -0.1, end: 0);
  }

  Widget _buildSuccessMessage(ResponsiveInfo r) {
    final theme = Theme.of(context);
    final titleStyle = (theme.textTheme.headlineSmall ?? const TextStyle()).copyWith(fontSize: AppTypography.heading(r));
    final messageStyle = (theme.textTheme.bodyMedium ?? const TextStyle()).copyWith(fontSize: AppTypography.bodyMedium(r));
    final buttonStyle = (theme.textTheme.labelMedium ?? const TextStyle()).copyWith(fontSize: AppTypography.bodyMedium(r));

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: theme.colorScheme.secondary, size: 64),
            const SizedBox(height: 16),
            SelectableText('Message Sent!', style: titleStyle),
            const SizedBox(height: 8),
            SelectableText(
              'Thank you for reaching out. I\'ll get back to you as soon as possible.',
              style: messageStyle, textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                _nameController.clear();
                _emailController.clear();
                _messageController.clear();
                context.read<PortfolioBloc>().add(LoadPortfolioData());
              },
              child: Text('Send Another Message', style: buttonStyle),
            ),
          ],
        ),
      ),
    ).animate().fade(duration: 400.ms).scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1));
  }

  Widget _buildContactInfo(BuildContext context, ContactInfoModel contactInfo, ResponsiveInfo r) {
    final theme = Theme.of(context);
    final titleStyle = (theme.textTheme.headlineSmall ?? const TextStyle()).copyWith(fontSize: AppTypography.heading(r));
    final mediumTitleStyle = (theme.textTheme.titleMedium ?? const TextStyle()).copyWith(fontSize: AppTypography.title(r));
    final buttonLabelStyle = (theme.textTheme.labelMedium ?? const TextStyle()).copyWith(fontSize: AppTypography.bodyMedium(r));
    final itemTitleStyle = (theme.textTheme.titleSmall ?? const TextStyle()).copyWith(fontSize: AppTypography.bodyMedium(r));
    final itemValueStyle = (theme.textTheme.bodyMedium ?? const TextStyle()).copyWith(fontSize: AppTypography.bodyMedium(r));

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectableText('Contact Information', style: titleStyle),
            const SizedBox(height: 24),
            InkWell(
              onTap: () async {
                final url = Uri.parse('mailto:${contactInfo.email ?? ''}');
                if (await canLaunchUrl(url)) launchUrl(url);
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(children: [
                  Icon(Icons.email, color: theme.colorScheme.primary),
                  const SizedBox(width: 16),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    SelectableText('Email', style: itemTitleStyle),
                    SelectableText(contactInfo.email ?? '', style: itemValueStyle),
                  ])),
                ]),
              ),
            ),
            const SizedBox(height: 16),
            SelectableText('Social', style: mediumTitleStyle),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(icon: FaIcon(FontAwesomeIcons.linkedin, color: theme.colorScheme.primary), iconSize: 30,
                    onPressed: () async { if (contactInfo.linkedIn.isNotEmpty) { final u = Uri.parse(contactInfo.linkedIn); if (await canLaunchUrl(u)) launchUrl(u); } }),
                IconButton(icon: FaIcon(FontAwesomeIcons.github, color: theme.colorScheme.primary), iconSize: 30,
                    onPressed: () async { if (contactInfo.github.isNotEmpty) { final u = Uri.parse(contactInfo.github); if (await canLaunchUrl(u)) launchUrl(u); } }),
                IconButton(icon: FaIcon(FontAwesomeIcons.twitter, color: theme.colorScheme.primary), iconSize: 30,
                    onPressed: () async { if (contactInfo.twitter.isNotEmpty) { final u = Uri.parse(contactInfo.twitter); if (await canLaunchUrl(u)) launchUrl(u); } }),
              ],
            ),
            if (contactInfo.calendlyLink.isNotEmpty) ...[
              const Divider(),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () async {
                  final url = Uri.parse(contactInfo.calendlyLink);
                  if (await canLaunchUrl(url)) launchUrl(url);
                },
                icon: const Icon(Icons.calendar_today),
                label: Text('Schedule a Meeting', style: buttonLabelStyle),
              ),
            ],
          ],
        ),
      ),
    ).animate().fade(duration: 400.ms).slideX(begin: 0.1, end: 0);
  }
}
