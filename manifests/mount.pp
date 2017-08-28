# == Define: autofs::mount

define autofs::mount (
  $map,
  $ensure     = present,
  $mountpoint = $title,
  $options    = undef,
  $mapfile    = undef,
  $order      = undef,
) {
  include ::autofs
  include ::autofs::params

  if $mapfile != undef {
    validate_absolute_path($mapfile)
    $path = $mapfile
  } else {
    $path = $autofs::params::master
  }

  autofs::mapfile { "autofs::mount ${title}":
    path => $path,
  }

  if $ensure == present {
    concat::fragment { "autofs::mount ${path}:${mountpoint}":
      target  => $path,
      content => "${mountpoint} ${map} ${options}\n",
      order   => '100',
    }
  }

}
