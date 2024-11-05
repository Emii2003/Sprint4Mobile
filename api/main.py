from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from pymongo import MongoClient
from pymongo.errors import DuplicateKeyError
from bson.objectid import ObjectId
from fastapi.middleware.cors import CORSMiddleware


# Instância da aplicação FastAPI
app = FastAPI()

# Permitir CORS para o seu app Flutter Web
origins = [
    "http://localhost",        # Para o ambiente de desenvolvimento local
    "http://127.0.0.1",       # Para desenvolvimento local
    "http://192.168.1.100",    # Se estiver usando um IP local
    "http://localhost:8000",   # Caso a API e o app estejam rodando na mesma máquina
    "*"                        # Para permitir todas as origens (não recomendado para produção)
]

# Adicionar o middleware CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,   # Permitir origens especificadas
    allow_credentials=True,
    allow_methods=["*"],     # Permitir todos os métodos HTTP
    allow_headers=["*"],     # Permitir todos os cabeçalhos
)


# Conectar ao MongoDB
client = MongoClient("mongodb://localhost:27017")
db = client["Sprint4Mob"]
collection = db["usuario"]

# Classe Pydantic para o modelo de dados do usuário
class Usuario(BaseModel):
    nome_usuario: str
    email_corporativo_usuario: str
    senha_usuario: str


# Endpoint para obter todos os usuários
@app.get("/usuario")
async def read_users():
    try:
        users = []
        # Buscar todos os documentos na coleção
        for user in collection.find():
            print(user)
            # Ajustar o _id para ser uma string antes de retornar
            user['_id'] = str(user['_id'])
            users.append(user)
        
        return users

    except Exception as e:
        print(f"Erro ao processar os documentos: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Erro na aplicação: {str(e)}")

# Endpoint para obter um usuário específico pelo id
@app.get("/usuario/{id}")
async def read_user_by_id(id: str):
    try:
        user = collection.find_one({"_id": ObjectId(id)})
        if user:
            user['_id'] = str(user['_id'])  # Ajusta o _id para string
            return user
        else:
            raise HTTPException(status_code=404, detail="Usuário não encontrado")
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Erro na aplicação: {str(e)}")

# Endpoint para registrar um novo usuário
@app.post("/usuario")
async def register_user(usuario: Usuario):
    try:
        # Inserir o novo usuário na coleção
        collection.insert_one(usuario.dict())
        return {"message": "Usuário registrado com sucesso!"}
    except DuplicateKeyError:
        raise HTTPException(status_code=400, detail="Usuário já existe")
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Erro na aplicação: {str(e)}")

# Endpoint para deletar um usuário pelo id
@app.delete("/usuario/{id}")
async def delete_user(id: str):
    try:
        result = collection.delete_one({"_id": ObjectId(id)})
        if result.deleted_count == 1:
            return {"message": "Usuário deletado com sucesso!"}
        else:
            raise HTTPException(status_code=404, detail="Usuário não encontrado")
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Erro na aplicação: {str(e)}")

# Endpoint para atualizar um usuário pelo id
@app.put("/usuario/{id}")
async def update_user(id: str, usuario: Usuario):
    try:
        # Atualizar o usuário na coleção
        result = collection.update_one({"_id": ObjectId(id)}, {"$set": usuario.dict()})
        
        if result.modified_count == 1:
            return {"message": "Usuário atualizado com sucesso!"}
        else:
            raise HTTPException(status_code=404, detail="Usuário não encontrado ou nenhuma alteração foi feita")
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Erro na aplicação: {str(e)}")
