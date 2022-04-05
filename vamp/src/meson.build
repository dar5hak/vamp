vamp_sources = [
    'models/Bugs.vala',
    'models/FundingInfo.vala',
    'models/Package.vala',
    'models/Person.vala',
    'models/Repository.vala',
]

vamp_lib = library(
    'vamp',
    vamp_sources,
    vala_header: 'vamp.h',
    vala_vapi: 'vamp.vapi',
    dependencies: dependencies,
)

vamp_dep = declare_dependency(
    include_directories: include_directories('.'),
    link_with: vamp_lib,
)
