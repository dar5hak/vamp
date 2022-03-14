
if get_option('tests')
    configure_file (
        input: 'config.vapi.in',
        output: 'config.vapi',
        copy: true
    )

    conf = configuration_data()
    conf.set_quoted ('TEST_PACKAGE_FILE', meson.current_source_dir() / 'assets' / 'vamp.json')
    conf.set_quoted ('FULL_TEST_PACKAGE_FILE', meson.current_source_dir() / 'assets' / 'full-vamp.json')
    conf.set_quoted ('BASIC_EXPECTED_TEST_PACKAGE_FILE', meson.current_source_dir() / 'assets' / 'expected-basic-vamp.json')
    conf.set_quoted ('FULL_EXPECTED_TEST_PACKAGE_FILE', meson.current_source_dir() / 'assets' / 'expected-full-vamp.json')

    configure_file (
        output: 'config.h',
        configuration: conf
    )

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
        dependencies: test_dependencies,
        vala_args: vala_args
    )

    test('vamp-tests', test_executable)

endif
