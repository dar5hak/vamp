
if get_option('tests')
    configure_file (
        input: 'config.vapi.in',
        output: 'config.vapi',
        copy: true
    )

    configure_file (
        output: 'config.h',
        configuration: {
            'TEST_PACKAGE_FILE': '"' + meson.current_source_dir() / 'assets' / 'vamp.json' + '"',
            'FULL_TEST_PACKAGE_FILE': '"' + meson.current_source_dir() / 'assets' / 'full-vamp.json' + '"',
            'BASIC_EXPECTED_TEST_PACKAGE_FILE': '"' + meson.current_source_dir() / 'assets' / 'expected-basic-vamp.json' + '"',
            'FULL_EXPECTED_TEST_PACKAGE_FILE': '"' + meson.current_source_dir() / 'assets' / 'expected-full-vamp.json' + '"',
        }
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
