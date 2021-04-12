Pod::Spec.new do |s|
  s.name = 'SceneMachine'
  s.version = '0.0.3'
  s.summary = 'The SceneMachine manages the stages of a view'
  s.description = 'The SceneMachine manages the stages of a view (loading, empty, error, content)'
  s.homepage = 'https://github.com/duytph/SceneMachine'
  s.license = { :type => 'WTFPL', :file => 'LICENSE' }
  s.author = { 'Duy Tran' => 'tphduy@gmail.com' }
  s.source = { :git => 'https://github.com/duytph/SceneMachine.git', :tag => s.version.to_s }
  s.swift_versions  = '5.3'
  s.ios.deployment_target = '10.0'
  s.source_files = 'Sources/SceneMachine/**/*.{swift}'
end
