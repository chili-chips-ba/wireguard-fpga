from .translator import TranslatorSpec

class Bitbucket(TranslatorSpec):
    remote_regexes = [
        r'git@bitbucket\.org:(?P<project_name>[\w\-]+)/(?P<repo>[\w\-]+)\.git',
        r'https://[\w\-]+@bitbucket\.org/(?P<project_name>[\w\-]+)/(?P<repo>[\w\-]+)\.git',
    ]

    url_root_recipes = [
        "https://bitbucket.org/{project_name}/{repo_name}/",
    ]

    url_body_recipes = [
        "src/{branch_name}/{path}",
        "src/{commit_hash}/{path}",
    ]

    url_suffix_recipes = [
        ("#lines-{start_line}:{end_line}", "is_folder == False"),
        ("#lines-{line}", "is_folder == False"),
        "",
    ]
