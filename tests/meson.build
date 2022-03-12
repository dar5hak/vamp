if get_option('tests')

conft = configuration_data()
configure_file (
    input: 'config.vapi.in',
    output: 'config.vapi',
    configuration: conft
)
confht = configuration_data()
confht.set_quoted ('TEST_PACKAGE_FILE', meson.current_source_dir() / 'vamp.json')
configure_file(output : 'config.h',
    configuration : confht)


vala_args = [
    '--vapidir', meson.current_build_dir(),
    '--pkg', 'config'
]

test_sources = [
    'UnitTests.vala'
]

test_dependencies = [
    vamp_dep,
]

foreach dep : dependencies
    test_dependencies += dep
endforeach

test_executable = executable('vamp-tests', test_sources,
    dependencies: test_dependencies
)

file_test_executable = executable('file-test', 'FileTest.vala',
    dependencies: test_dependencies,
    vala_args: vala_args,
)

test('vamp-tests', test_executable)
test('file-test', file_test_executable)

endif
