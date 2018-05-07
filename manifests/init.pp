# Test and demonstration of some puppet features.

class demo {

    # 01 - Augeas and xml

    file { '/demo': ensure => directory }

    file { '/demo/books.xml':
        ensure  => present,
        source  => 'puppet:///modules/demo/books.xml',
        replace => false,
    }

    $dqdescr = join([
        'The adventures of a noble hidalgo who reads so many chivalric',
        ' romances that he loses his sanity and decides to set out to revive',
        ' chivalry, undo wrongs, and bring justice to the world, under the',
        ' name Don Quixote de la Mancha.',
    ], '')

    $dqid = 'bk102'

    augeas { 'Add descr. and genre for Don Quixote':
        root    => '/demo',
        incl    => '/books.xml',
        lens    => 'Xml.lns',
        context => '/files/books.xml',
        changes => [
          "defnode targetnode catalog/book[#attribute[id=\"${dqid}\"]]/description ''",
          'set $targetnode/#attribute/genre "Novel"',
          "set \$targetnode/#text '${dqdescr}'",
          'clear $targetnode',
        ]
    }



    # 02 - String formats
    # Sources :
    # http://puppet-on-the-edge.blogspot.fr/2016/05/converting-and-formatting-data-like-pro.html
    # https://github.com/puppetlabs/puppet-specifications/blob/master/language/types_values_variables.md
    # With puppet 5 : OK
    # With puppet 4 : not working as expected

    $things = [
      'Cream colored ponies',
      'crisp apple strudels',
      'door bells',
      'sleigh bells',
      'schnitzel with noodles'
    ]

    $formats = {
        Array => {
            format         => '% a',
            separator      => ', ',
            string_formats => {
                # %s is unquoted string
                String => '%s',
            }
        }
    }

    file { '/tmp/favorite_things.txt':
        content =>
          "${String($things, $formats)}. These are a few of my favourite things.\n",
    }



    # 03 - Writing a function in the Puppet language
    # Cf functions/mary_poppinsify.pp

    $otherthings = [ 'keys on pianos', 'food in a bento' ]

    $ftbis = demo::mary_poppinsify($formats, $things, $otherthings)

    file { '/tmp/favorite_things-bis.txt': content => $ftbis, }



    # 04 - Writing a function with the The modern Ruby functions API
    # Cf lib/puppet/functions/mary_poppinsify.rb

    $ftter = mary_poppinsify($things, $otherthings)

    file { '/tmp/favorite_things-ter.txt': content => $ftter, }



    # 05 - inline ruby

    file { '/tmp/favorite_things-quater.txt':
        content => inline_template(
        "<%= @things.join(', ') %>. These are a few of my favourite things.\n",
        ),
    }

}

