sources = [
    'main.vala',
]

 vamp_lib = library(
    'vamp',
    [
        'models/Bugs.vala',
        'models/FundingInfo.vala',
        'models/Package.vala',
        'models/Person.vala',
        'models/Repository.vala',
    ],
    vala_header: 'vamp.h',
    vala_vapi: 'vamp.vapi',
    dependencies: dependencies,
)

vamp_dep = declare_dependency(
    include_directories: include_directories('.'),
    link_with: vamp_lib,
)

executable('vamp', 
    sources, 
    dependencies: [dependencies , vamp_dep],
    install: true,
)
