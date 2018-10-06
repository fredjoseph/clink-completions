local path_utils = require('path_utils')

local parser = clink.arg.new_parser
local scoop_dir = clink.get_env('HOME')..'/scoop'

local Buckets = {}
local Apps = {}

local function find_dirs (path)
	dirs = clink.find_dirs(path)
	-- Remove .. and . from table of directories
	table.remove(dirs, 1)
	table.remove(dirs, 1)
	return dirs
end

function Buckets.get_local ()
	return find_dirs(scoop_dir..'/buckets/*')
end

function Buckets.get_known ()
	json = io.open(scoop_dir..'/apps/scoop/current/buckets.json')
	known = {}
	for line in json:lines() do
		bucket = string.match(line, '\"(.-)\"')
		if bucket then
			table.insert(known, bucket)
		end
	end
	return known
end

function Apps.get_local ()
	return find_dirs(scoop_dir..'/apps/*')
end

function Apps.get_known ()
	apps = path_utils.trim_extensions(clink.find_files(scoop_dir..'/apps/scoop/current/bucket/*.json'))
	for _, dir in pairs(Buckets.get_local()) do
		for u, app in pairs(path_utils.trim_extensions(clink.find_files(scoop_dir..'/buckets/'..dir..'/*.json'))) do
			table.insert(apps, app)
		end
	end
	return apps
end

local architectures = parser({
    "32bit",
    "64bit"
})

local scoop_parser = parser(
	{
        'alias' .. parser({'add', 'list', 'rm'}),
        'bucket' .. parser({'add' .. parser({Buckets.get_known}), 'list', 'known', 'rm' .. parser({Buckets.get_local})}),
        'cache' .. parser({'show', 'rm' .. parser({Apps.get_local, '*'}):loop(0)}),
        'checkup',
        'cleanup' .. parser({Apps.get_local, '*'}, '-g', '--global'):loop(0),
        'config' .. parser({'rm'}),
        'create',
        {'depends', 'home', 'info'} .. parser({Apps.get_known}),
        'export',
        'install' .. parser({Apps.get_known}, 
            '-g', '--global',
            '-i', '--independent',
            '-k', '--no-cache',
            '-s', '--skip',
            '-a' .. architectures, '--arch' .. architectures):loop(0),
        'list',
        {'prefix', 'reset'} .. parser({Apps.get_local}),
        'search',
        'status',
        'uninstall' .. parser({Apps.get_local}, '-g', '--global', '-p', '--purge'):loop(0),
        'update' .. parser({Apps.get_local, '*'}, 
            '-f', '--force',
            '-g', '--global',
            '-i', '--independent',
            '-k', '--no-cache',
            '-s', '--skip',
            '-q', '--quiet'
            ):loop(0),
        "virustotal" .. parser({Apps.get_known, '*'}, 
            '-a' .. architectures, '--arch' .. architectures,
            '-s', '--scan',
            '-n', '--no-depends'
            ):loop(0),
        'which'
	}
)

local help_parser = parser(
	{
        'help' .. parser(scoop_parser:flatten_argument(1))
	}
)

clink.arg.register_parser('scoop', scoop_parser)
clink.arg.register_parser('scoop', help_parser)
