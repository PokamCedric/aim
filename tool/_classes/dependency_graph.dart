// Copyright 2023 The terCAD team. All rights reserved.
// Use of this source code is governed by a CC BY-NC-ND 4.0 license that can be found in the LICENSE file.

import 'dart:io';
import 'package:path/path.dart' as path;

typedef FilesStructure = Map<String, Map<String, List<String>>>;

class DependencyGraph {
  static const eol = '\n';
  final graph = StringBuffer();

  DependencyGraph() {
    graph.writeAll([
      'digraph G {',
      '  node [shape=record, width=.1, height=.1];',
      '  ranksep=.75;',
      '  edge [penwidth=1.3];',
      '  nodesep=.05;',
      '  rankdir=LR;',
      '',
    ], eol);
  }

  void init(List<String> files) {
    final structure = _convert(files);
    final groundList = structure.keys.toList();
    groundList.sort();
    graph.writeAll([
      '  {',
      '    node [shape=plaintext, fontsize=16];',
      '    past -> ${groundList.map((e) => '"$e" -> ').join()} "future";',
      '  }',
      '',
    ], eol);
  }

  void bind(List<String> files, [String postfix = '', String color = 'silver:white']) {
    final structure = _convert(files);
    for (var entry in structure.entries) {
      for (var sub in entry.value.entries) {
        graph.writeAll([
          '  {',
          '    rank = same; "${entry.key}";',
          '    ${sub.key.replaceAll('/', '_')}$postfix ['
              'label="<0>${sub.key.replaceAll('/', ' / ').toUpperCase()}$postfix'
              '|${sub.value.map((e) => '<$e>$e').join('|')}",'
              'fillcolor="$color", gradientangle=240, style="filled"'
              '];',
          '  }',
          '',
        ], eol);
      }
    }
  }

  void connect(List<String> files, [String postfix = '', String? color]) {
    for (final from in files) {
      final file = File(path.join(Directory.current.path, 'lib/$from'));
      parse(file.readAsStringSync(), from, postfix, color ?? _getColor(from));
    }
  }

  void parse(String content, String from, String postfix, String color) {
    final dependencies = <String>{};
    final search = RegExp("import 'package:aim/(.*?).dart';");
    for (final to in search.allMatches(content).where((v) => v.groupCount > 0).map((v) => v.group(1)!).toList()) {
      if (postfix.isNotEmpty && _contains(to, postfix)) {
        dependencies.add('  ${_convertPath(from, postfix.isEmpty, postfix)}'
            ' -> ${_convertPath(to, postfix.isEmpty, postfix)} [color="$color"];');
      } else {
        dependencies.add('  ${_convertPath(from, postfix.isEmpty, postfix)}'
            ' -> ${_convertPath(to, postfix.isEmpty)} [color="$color"];');
      }
    }
    graph.writeln(dependencies.toList().join(eol));
  }

  bool _contains(String path, String postfix) =>
      graph.toString().contains(RegExp(_convertPath(path, false, postfix).replaceAll(':', '(.*?)')));

  @override
  String toString() => '${graph.toString()}}';

  FilesStructure _convert(List<String> files) {
    final FilesStructure structure = {};
    for (final filePath in files) {
      final parts = filePath.split('/');
      if (parts.length <= 1) {
        continue;
      }
      final key = parts[1];
      if (structure[key] == null) {
        structure[key] = {};
      }
      final path = _convertPath(filePath, false).split(':');
      final sub = path[0];
      if (structure[key]![sub] == null) {
        structure[key]![sub] = [];
      }
      structure[key]![sub]!.add(path[1]);
    }
    return structure;
  }

  String _convertPath(String filePath, [bool isShort = true, String postfix = '']) {
    if (filePath.startsWith('/')) {
      filePath = filePath.replaceFirst('/', '');
    }
    final parts = filePath.split('/');
    String sub = '';
    if (parts.length > 1) {
      sub = parts.sublist(1, parts.length - 1).join('_');
    }
    if (sub.isEmpty) {
      sub = '${parts.first}_';
    }
    return isShort ? sub : '$sub$postfix:${parts.last.replaceAll('.dart', '')}';
  }

  String _getColor(String filePath) => switch (filePath.replaceAll(RegExp('^/'), '').split('/')[0]) {
        '_classes' => 'green',
        '_configs' => 'green',
        '_ext' => 'green',
        '_mixins' => 'green',
        'charts' => 'red',
        'components' => '#FF00FF50',
        'design' => '#0000FF50',
        _ => '#F0F0F050',
      };
}
