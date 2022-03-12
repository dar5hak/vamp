sources = [
    'models/Package.vala',
    'main.vala',
]

executable('vamp', sources,
    dependencies: dependencies,
    install: true,
)


vamp_lib = library(
    'vamp',
    ['models/Package.vala'],
    vala_header: 'vamp.h',
    vala_vapi: 'vamp.vapi',
    dependencies: dependencies,
)

vamp_dep = declare_dependency(
    include_directories: include_directories('.'),
    link_with: vamp_lib,
)
