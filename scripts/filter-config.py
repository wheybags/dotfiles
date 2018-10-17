import typing
import xml.etree.ElementTree
import xml.dom.minidom
import re
import os
import sys


class Config:
    def __init__(self, data: typing.Dict[str, str]):
        self.data = data

    def save(self, output_path: str):
        raise NotImplementedError()

    def filter_for_git(self, include: typing.List[str], exclude: typing.List[str]):
        new_data = {}

        for key in self.data:
            passed = False

            for pattern in include:
                if re.match(pattern, key):
                    passed = True
                    break

            if not passed:
                continue

            for pattern in exclude:
                if re.match(pattern, key):
                    continue

            new_data[key] = self.data[key]

        self.data = new_data

    def override(self, other: "Config"):
        self.data.update(other.data)


class XmlConfig(Config):
    def __init__(self, input_path: str):
        super().__init__(XmlConfig.parse_xml_config(input_path))

    def save(self, output_path: str):
        XmlConfig.save_xml_config(self.data, output_path)

    @staticmethod
    def parse_xml_config(input_path: str) -> typing.Dict[str, str]:
        root = xml.etree.ElementTree.parse(input_path).getroot()

        parsed_data = {}

        def recursive_parse(i: int, elem, path_so_far: str):
            full_path = path_so_far + "::" + elem.tag + "_XXX" + str(i).zfill(3) + "XXX"
            parsed_data[full_path] = (elem.text or '').strip()

            for i, child in enumerate(elem):
                recursive_parse(i, child, full_path)

        recursive_parse(0, root, 'root')

        return parsed_data

    @staticmethod
    def save_xml_config(data: typing.Dict[str, str], output_path: str):
        root = {}

        for key in sorted(data.keys()):
            levels = key.split('::')[1:]
            node = root
            for level in levels:
                if level not in node:
                    node[level] = {}

                node = node[level]

            node["__text"] = data[key]

        tab = '    '

        def recursive_str(node, tab_level: int):
            retval = []

            for child in sorted(node.keys()):
                if child == "__text":
                    continue

                if "__text" in node[child] and len(node[child]["__text"]):
                    retval += [tab * tab_level, '<', child, '>', node[child]["__text"], '</', child, '>\n']
                else:
                    retval += [tab * tab_level, '<', child, '>\n']
                    retval += recursive_str(node[child], tab_level + 1)
                    retval += [tab * tab_level, '</', child, '>\n']

            return retval

        str_list = recursive_str(root, 0)
        out_data = ''.join(str_list)
        out_data = re.sub(r'_XXX[0-9][0-9][0-9]XXX', '', out_data)

        with open(output_path, "w") as f:
            f.write(out_data)


def main():
    base_dir = os.path.abspath(__file__ + "/../../")
    configs = []
#    [(base_dir + "/keepass/KeePass.config.xml",
#                base_dir + "/keepass/filtered.xml",
#                [r'.*ClipboardClearAfterSeconds.*',
#                 r'.*FocusQuickFindOnRestore.*',
#                 r'.*FocusQuickFindOnUntray.*'],
#                []
#               )]

    if len(sys.argv) != 2 or sys.argv[1] not in ("orig_to_filt", "filt_to_orig"):
        print("usage filter-config.py orig_to_filt/filt_to_orig")
        exit(1)

    for original, filtered, include, exclude in configs:

        if sys.argv[1] == "orig_to_filt":
            if filtered.endswith(".xml"):
                config = XmlConfig(original)
            else:
                raise Exception("unknown config type: ", original, filtered)

            config.filter_for_git(include, exclude)

            config.save(filtered)
        else:
            if filtered.endswith(".xml"):
                filtered_config = XmlConfig(filtered)
                original_config = XmlConfig(original)
            else:
                raise Exception("unknown config type: ", original, filtered)

            original_config.override(filtered_config)
            original_config.save(original)


if __name__ == "__main__":
    main()
