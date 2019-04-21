Pod::Spec.new do |s|
  s.name        = 'UIPreviewActivityViewController'
  s.module_name = 'UIPreviewActivityViewController'
  s.version     = '1.1.0'
  s.summary     = 'An UIActivityViewController with preview.'

  s.homepage    = 'https://github.com/Meniny/UIPreviewActivityViewController'
  s.license     = { type: 'MIT', file: 'LICENSE.md' }
  s.authors     = { 'Elias Abel' => 'admin@meniny.cn' }
  s.social_media_url = 'https://meniny.cn/'

  s.ios.deployment_target     = '9.0'
  # s.osx.deployment_target     = '10.10'
#  s.tvos.deployment_target    = '9.0'
#  s.watchos.deployment_target = '2.0'

  s.requires_arc        = true
  s.source              = { git: 'https://github.com/Meniny/UIPreviewActivityViewController.git', tag: s.version.to_s }
  s.source_files        = 'UIPreviewActivityViewController/**/*.swift'
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '5' }
  s.swift_version       = '5'
end
