// Copyright 2024 The terCAD team. All rights reserved.
// Use of this source code is governed by a CC BY-NC-ND 4.0 license that can be found in the LICENSE file.

import 'package:aim/application/state/app_design.dart';
import 'package:aim/core/_mixins/launcher_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MarkdownBuilderWrapper extends StatelessWidget with LauncherMixin {
  final String url;
  final Widget Function(BuildContext, AsyncSnapshot<String>)? builder;
  final Function(String, String?, String)? onTapLink;

  const MarkdownBuilderWrapper({
    super.key,
    required this.url,
    this.builder,
    this.onTapLink,
  });

  void _openURL(_, String? url, _) {
    if (url != null && (url.contains('https://') || url.contains('mailto:'))) {
      openURL(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DefaultAssetBundle.of(context).loadString(url),
      builder: builder ??
          (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              return Directionality(
                textDirection: AppDesign.getAlignment<TextDirection>(),
                child: Markdown(
                    data: (snapshot.data ?? '').replaceAll('../images', 'resource:assets/images'),
                    onTapLink: onTapLink ?? _openURL),
              );
            }
            return Container();
          },
    );
  }
}
