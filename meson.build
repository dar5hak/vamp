project('vamp', 'vala', 'c',
    version: '0.0.1'
)

dependencies = [
    dependency('glib-2.0'),
    dependency('gobject-2.0'),
    dependency('gee-0.8'),
    dependency('json-glib-1.0'),
]

add_project_arguments(['--enable-experimental'], language: 'vala')

subdir('vamp')
subdir('cli')
