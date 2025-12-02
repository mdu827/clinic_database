from fastapi import APIRouter, Request, Depends
from fastapi.templating import Jinja2Templates
from fastapi.responses import HTMLResponse

router = APIRouter(prefix='/pages', tags=['Фронтенд'])
templates = Jinja2Templates(directory='app/templates')

@router.get('/documentation', response_class=HTMLResponse)
async def get_documentation_page(request: Request):
    """Страница с документацией API"""
    return templates.TemplateResponse(
        name='documentation.html', 
        context={'request': request}
    )

@router.get('/', response_class=HTMLResponse)
async def get_main_page(request: Request):
    """Главная страница клиники"""
    return templates.TemplateResponse(
        name='index.html', 
        context={'request': request}
    )