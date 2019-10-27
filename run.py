#!/usr/bin/env python

'''
 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, version 3.
 This program is distributed in the hope that it will be useful, but
 WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 General Public License for more details.
 You should have received a copy of the GNU General Public License
 along with this program. If not, see <http://www.gnu.org/licenses/>.
'''

from aiohttp import web
from aiohttp_sse import sse_response
import asyncio
import json
import aiohttp_jinja2
import jinja2
import os

games = {
    'b3' : {
        'devices' : {
            1234 : {
                'name' : 'Arthur'
            },
            5678 : {
                'name' : 'Alicia'
            }
        },
        'devices_changed' : asyncio.Condition()
    }
}

routes = web.RouteTableDef()
ROOT = os.path.dirname(__file__)

@routes.get('/{game_name}/devices')
async def devices(request):
    game_name = request.match_info['game_name']
    game = games[game_name]
    devices_changed = game['devices_changed']
    async with sse_response(request) as resp:
        while True:
            devices = game['devices'] 
            await resp.send(json.dumps(devices))
            async with devices_changed:
                await devices_changed.wait() 
    return resp

@routes.get('/')
async def index(request):
    content = open(os.path.join(ROOT, 'html/index.html'), 'r').read()
    return web.Response(content_type='text/html', text=content)

@routes.get('/{style_name}.css')
async def style(request):
    style_name = request.match_info['style_name']
    content = open(os.path.join(ROOT, f'html/{style_name}.css'), 'r').read()
    return web.Response(content_type='text/css', text=content)

@routes.get('/scripts/{script_name}.js')
async def script(request):
    script_name = request.match_info['script_name']
    content = open(os.path.join(ROOT, f'html/scripts/{script_name}.js'), 'r').read()
    return web.Response(content_type='application/javascript', text=content)

@routes.get('/scripts/lib/{lib_name}.js')
async def lib(request):
    lib_name = request.match_info['lib_name']
    content = open(os.path.join(ROOT, f'html/scripts/lib/{lib_name}.js'), 'r').read()
    return web.Response(content_type='application/javascript', text=content)

app = web.Application()
app.add_routes(routes)
web.run_app(app)

